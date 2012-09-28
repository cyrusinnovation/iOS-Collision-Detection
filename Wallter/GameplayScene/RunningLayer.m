//
//  Wallter
//
//  Created by Najati Imam on 9/24/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


#import "RunningLayer.h"

#import "StageView.h"
#import "GuyView.h"
#import "Simulation.h"
#import "MeleeAttack.h"
#import "MeleeAttackView.h"
#import "BadGuyView.h"
#import "Platform.h"
#import "GuyController.h"

@implementation RunningLayer {
	Stage *stage;
	Guy *guy;
	Simulation *simulation;

	ccTime buffer;
	ccTime frameTime;
	CGPoint guyLoc;
	ccTime stuckTime;

	CCLabelTTF *scoreLabel;

	float score;

	DrawOffset *offset;

	GuyController *guyController;
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
	}
	return self;
}

- (void)initStage {
	[self removeAllChildrenWithCleanup:true];

	guyLoc = cgp(FLT_MIN, FLT_MIN);
	stuckTime = 0;
	score = 0;

	guy = [[Guy alloc] initAt:cgp(30, 50)];
	guyController = [GuyController from:self attackDelay:frameTime * 3];

	offset = [[DrawOffset alloc] init:guy];

	stage = [[Stage alloc] init];
	stage.listener = self;

	simulation = [[Simulation alloc] initFor:guy in:stage];

	[stage prime];

	[self addChild:[[StageView alloc] init:stage following:offset]];
	[self addChild:[[GuyView alloc] init:guy following:offset]];

	[self setUpScoreLabel];
}

- (void)setUpScoreLabel {
	scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:32.0f];
	scoreLabel.color = ccc3(108, 54, 54);
	CGSize s = [[CCDirector sharedDirector] winSize];
	NSLog(@"winsize %f %f", s.width, s.height);
	scoreLabel.position = cgp(s.width / 2, s.height - 30);
	[self addChild:scoreLabel z:100];
}

- (void)update:(ccTime)dt {
	buffer += dt * 0.8;
	while (buffer >= frameTime) {
		buffer -= frameTime;
		[self updateInternal:frameTime];
	}
}

- (void)updateInternal:(ccTime)dt {
	[simulation update:dt];
	[offset update];

	score += fabs(guy.location.x - guyLoc.x) * 0.07;
	// TODO OPT don't update the score string every frame
	[scoreLabel setString:[NSString stringWithFormat:@"%d", (int) score]];

	if (guy.location.y < stage.death_height || guy.dead) {
		[self initStage];
	} else {
		[stage generateAround:guy];
		[self checkForStuckedness:dt];
	}

	[guyController update:dt];
}

- (void)addedPlatform:(Platform *)platform {
	int numberOfBaddies = rand() % 4;
	if (numberOfBaddies == 0) return;

	float x = platform.center;
	float y = platform.top;

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
	[guyController touchStarted:location];
	return true;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	[guyController touchMoved:location];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	[guyController touchEnded:location];
}

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

#pragma mark controller endpoints

- (void)attack {
	MeleeAttack *attack = [[MeleeAttack alloc] init:guy];
	[simulation addAttack:attack];
	MeleeAttackView *view = [[MeleeAttackView alloc] init:attack following:offset];
	[self addChild:view];
}

- (void)jumpLeft{
	if ([guy jumpLeft] == wallJump) score += 57;
}

- (void)jumpRight {
	if ([guy jumpRight] == wallJump) score += 57;
}

@end