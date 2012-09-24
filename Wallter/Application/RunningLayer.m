//
//  Wallter
//
//  Created by Najati Imam on 9/24/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


#import "RunningLayer.h"

#import "Polygon.h"
#import "Stage.h"
#import "StageView.h"
#import "Guy.h"
#import "GuyView.h"
#import "Simulation.h"

@implementation RunningLayer {
	Stage *stage;
	Guy *guy;
	Simulation *simulation;

	ccTime buffer;
	ccTime frameTime;
	CGPoint touchStart;
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
	if ((self = [super initWithColor:(ccColor4B) {194, 233, 249, 255} width:s.height height:s.width])) {
		[self scheduleUpdate];
		self.isTouchEnabled = YES;

		buffer = 0;
		frameTime = 0.01;

		stage = [[Stage alloc] init];
		[stage addWall:make_block(0, 0, 1000, 50)];
		[stage addWall:make_block(1200, 0, 2200, 50)];
//		[stage addWall:make_block(400, 50, 450, 200)];

		guy = [[Guy alloc] initIn:stage at:cgp(30, 50)];

		simulation = [[Simulation alloc] initFor:guy in:stage];

		[self addChild:[[StageView alloc] init:stage following:guy]];
		[self addChild:[[GuyView alloc] init:guy]];
	}
	return self;
}

- (void)update:(ccTime)dt {
	buffer += dt;
	while (buffer >= frameTime) {
		buffer -= frameTime;
		[self updateInternal:frameTime];
	}
}

- (void)updateInternal:(ccTime)dt {
	[simulation update:dt];
}

- (void)dealloc {
	[stage release];
	[super dealloc];
}

#pragma mark Touch methods

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	touchStart = location;
	return true;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	CGPoint touchEnd = location;
	CGPoint swipe = cgp_subtract(touchEnd, touchStart);

	float length = cgp_length(swipe);
	float up = swipe.y/swipe.x;

	if (length > 10 && up > 1) {
		[guy jump];
	} else{
		[guy resetTo:cgp(30, 50)];
	}
}

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

@end