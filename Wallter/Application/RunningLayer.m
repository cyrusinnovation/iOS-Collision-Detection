//
//  Wallter
//
//  Created by Najati Imam on 9/24/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


#import <CoreGraphics/CoreGraphics.h>
#import "RunningLayer.h"

#import "Stage.h"
#import "StageView.h"
#import "GuyView.h"
#import "Simulation.h"
#import "MeleeAttack.h"
#import "MeleeAttackView.h"
#import "BadGuyView.h"
#import "DrawOffset.h"

@implementation RunningLayer {
	Stage *stage;
	Guy *guy;
	Simulation *simulation;

	ccTime buffer;
	ccTime frameTime;
	CGPoint guyLoc;
	ccTime stuckTime;

	CGPoint touchStart;
	CGPoint touchMove;
	bool touching;
	float touchTime;
	bool attackFromTouch;
	CCLabelTTF *scoreLabel;

	float score;

	DrawOffset *offset;
}

@synthesize stage;

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	RunningLayer *layer = [RunningLayer node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
	CGSize s = [[CCDirector sharedDirector] winSize];
	if ((self = [super initWithColor:(ccColor4B) {194, 233, 249, 255} width:s.width height:s.height])) {
		[self scheduleUpdate];
		self.isTouchEnabled = YES;

		buffer = 0;
		frameTime = 0.01;

		[self initStage];

		touching = false;
		touchTime = -1;
	}
	return self;
}

- (void)initStage {
	[self removeAllChildrenWithCleanup:true];

	stage = [[Stage alloc] init];
	[stage addWall:make_block(0, -50, 1000, 50)];

	guy = [[Guy alloc] initIn:stage at:cgp(30, 50)];
	offset = [[DrawOffset alloc] init:guy];
	guyLoc = cgp(FLT_MIN, FLT_MIN);
	stuckTime = 0;

	simulation = [[Simulation alloc] initFor:guy in:stage];

	[self addChild:[[StageView alloc] init:stage following:offset]];
	[self addChild:[[GuyView alloc] init:guy]];

	score = 0;

	scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:32.0f];
	scoreLabel.color = ccc3(108, 54, 54);
	CGSize s = [[CCDirector sharedDirector] winSize];
	NSLog(@"winsize %f %f", s.width, s.height);
	scoreLabel.position = cgp(s.width / 2, s.height - 30);
	[self addChild:scoreLabel z:100];
}

- (void)update:(ccTime)dt {
	buffer += dt * 1;
	while (buffer >= frameTime) {
		buffer -= frameTime;
		[self updateInternal:frameTime];
	}
}

- (void)updateInternal:(ccTime)dt {
	[simulation update:dt];

	score += cgp_length(cgp_subtract(guy.location, guyLoc));
	// TODO OPT don't update the score string every frame
	[scoreLabel setString:[NSString stringWithFormat:@"%d", (int) score/20*10]];

	if (guy.location.y < -100 || guy.dead) {
		[self initStage];
	} else {
		[stage generateAround:guy.location listener:self];
		[self checkForStuckedness:dt];
	}

	if (touching) {
		touchTime += dt;

		if (!attackFromTouch && touchTime > frameTime * 3) {

			CGPoint swipe = cgp_subtract(touchMove, touchStart);
			float length = cgp_length(swipe);
			if (length < 10) {
				MeleeAttack *attack = [[MeleeAttack alloc] init:guy];
				[simulation addAttack:attack];
				MeleeAttackView *view = [[MeleeAttackView alloc] init:attack];
				[self addChild:view];

				attackFromTouch = true;
			}
		}
	}
}

- (void)addedPlatform:(CGPolygon)platform {
	int numberOfBaddies = rand() % 4;
	if (numberOfBaddies == 0) return;

	float x = (platform.points[0].x + platform.points[1].x) / 2;
	float y = platform.points[3].y;

	if (numberOfBaddies < 3) {
		[self addBadguy:cgp(x, y)];
	} else {
		[self addBadguy:cgp(x - 80, y)];
		[self addBadguy:cgp(x + 80, y)];
	}
}

- (void)addBadguy:(CGPoint)location {
	BadGuy *badGuy = [[BadGuy alloc] init:location];
	[simulation addBadGuy:badGuy];
	[self addChild:[[BadGuyView alloc] init:badGuy withOffset:offset]];
}

- (void)checkForStuckedness:(ccTime)d {
	if (guy.location.x == guyLoc.x && guy.location.y == guyLoc.y) {
		stuckTime += d;
		if (stuckTime > 1) {
			[self initStage];
		}
	} else {
		guyLoc = guy.location;
	}
}

- (void)dealloc {
	[stage release];
	[super dealloc];
}

#pragma mark Touch methods

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	touchMove = touchStart = location;
	touching = true;
	return true;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	touchMove = location;
	CGPoint swipe = cgp_subtract(touchMove, touchStart);

	float length = cgp_length(swipe);

	if (length > 20) {
		if (swipe.y > 3) {
			if (swipe.x < 0) {
				[guy jumpLeft];
			} else if (swipe.x > 0) {
				[guy jumpRight];
			}
		}
	}
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	if (!attackFromTouch) {
		CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
		CGPoint touchEnd = location;
		CGPoint swipe = cgp_subtract(touchEnd, touchStart);

		float length = cgp_length(swipe);
		if (length <= 20) {
			MeleeAttack *attack = [[MeleeAttack alloc] init:guy];
			[simulation addAttack:attack];
			MeleeAttackView *view = [[MeleeAttackView alloc] init:attack];
			[self addChild:view];
		}
	}

	touching = false;
	touchTime = 0;
	attackFromTouch = false;
}

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

@end