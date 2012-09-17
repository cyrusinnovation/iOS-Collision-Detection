//
//  BouncingEggLayer.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


#import "SimulationObserver.h"
#import "BouncingEggLayer.h"

#import "CGPoint_ops.h"

#import "EggSprite.h"
#import "NestSprite.h"
#import "HUD.h"
#import "StarSprite.h"
#import "Simulation.h"

#pragma mark - HelloWorldLayer

#define TRAMPOLINE_LAYER 2
#define EGG_LAYER 3
#define STAR_LAYER 4

@implementation BouncingEggLayer {
	HUD *hud;
	Simulation *simulation;
}

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	BouncingEggLayer *layer = [BouncingEggLayer node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
	if (self = [super init]) {
		[self scheduleUpdate];
		self.isTouchEnabled = YES;

		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *bg = [CCSprite spriteWithFile:@"eggbackground.png"];
		[bg setPosition:ccp(s.width / 2, s.height / 2)];
		[self addChild:bg z:0];

		simulation = [[Simulation alloc] initWithInitialEggLocation:s.width / 2 and:s.height + 100];
		simulation.observer = self;

		[self addChild:[[EggSprite alloc] init:simulation.egg] z:EGG_LAYER tag:EGG_LAYER];

		[self startStageOver];


		clouds = [[Clouds alloc] init];
		[self addClouds];

		nest = [[Nest alloc] initAt:s.width / 4 and:60];
		[self addChild:[[NestSprite alloc] init:nest]];

		score = [[Score alloc] init];
		hud = [[HUD alloc] initWithScore:score];
		[self addChild:hud];

	}
	return self;
}

- (void)startStageOver {
	[simulation resetCurrentArrangement];
	[simulation addStarAt:0.25 and:0.75];
	[simulation addStarAt:0.75 and:0.50];
	[simulation addStarAt:0.35 and:0.30];
}

- (void)addClouds {
	for (CCSprite *cloud in [clouds cloudSprites]) {
		[self addChild:cloud z:0];
	}
}

- (void)resetStage {
	// TODO eventually this should look like:
	//  [simulation loadStage:stage]
	//  or something and we probably shouldn't
	//  pause the directory

	[[CCDirector sharedDirector] resume];

	[simulation resetCurrentStage];

	[score reset];
	[self startStageOver];

	while ([self getChildByTag:2]) {
		[self removeChildByTag:2 cleanup:true];
	}
}

// TODO move these to the class
static ccTime buffer = 0;
static ccTime frameTime = 0.01;

- (void)update:(ccTime)dt {
	buffer += dt;
	while (buffer >= frameTime) {
		buffer -= frameTime;
		[self updateInternal:frameTime];
	}
}

- (void)updateInternal:(ccTime)dt {
	if ([simulation isEggDead]) {
		[score adjustBy:1];
		[self startStageOver];
	} else {
		[simulation update:dt];
		[nest handle:simulation.egg];
	}
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];

	newTrampolineAnchor = location;
	newTrampoline = [[Trampoline alloc] initFrom:newTrampolineAnchor to:newTrampolineAnchor];
	newTrampolineSprite = [[TrampolineSprite alloc] init:newTrampoline];

	[self addChild:newTrampolineSprite z:2 tag:2];

	return true;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];

	[newTrampoline setFrom:newTrampolineAnchor to:location];
	[newTrampolineSprite update:0];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	
	if (location.x < 40 && location.y > 440) {
		newTrampoline = NULL;
		[self resetStage];
		return;
	}

	[simulation addTrampolineFrom:newTrampolineAnchor to:location];

	[self removeChild:newTrampolineSprite cleanup:true];
	newTrampoline = NULL;
}

#pragma mark SimulationObserver stuff

- (void)newStar:(Star *)star {
	[self addChild:[[StarSprite alloc] init:star] z:STAR_LAYER tag:STAR_LAYER];
}

- (void)starCaught:(Star *)star {
	for (NSObject *child in [self children]) {
		if ([child isMemberOfClass:[StarSprite class]]) {
			StarSprite *starSprite = (StarSprite *) child;
			if (starSprite.star == star) {
				[self removeChild:starSprite cleanup:true];
			}
		}
	}
}

- (void)newTrampoline:(Trampoline *)trampoline {
	[self addChild:[[TrampolineSprite alloc] init:trampoline] z:TRAMPOLINE_LAYER tag:TRAMPOLINE_LAYER];
}

#pragma mark -

- (void)dealloc {
	[super dealloc];
}

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


@end
