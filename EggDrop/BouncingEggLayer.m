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
#import "Level.h"
#import "GameOverLayer.h"

#pragma mark - HelloWorldLayer

#define TRAMPOLINE_LAYER 2
#define EGG_LAYER 3
#define NEST_LAYER 3
#define STAR_LAYER 4
#define MENU_LAYER 100

#define MENU_LAYER_TAG 100

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

		Level *level = [[Level alloc] init];
		level.initialEggLocation = cgp(s.width / 2, s.height + 100);
		level.nestLocation = cgp(s.width / 4, 60);
		[level addStar:cgp(0.25, 0.75)];
		[level addStar:cgp(0.75, 0.50)];
		[level addStar:cgp(0.35, 0.30)];

		simulation = [[Simulation alloc] init:level];
		simulation.observer = self;
		[simulation startLevelOver];

		[self addChild:[[EggSprite alloc] init:simulation.egg] z:EGG_LAYER tag:EGG_LAYER];
		[self addChild:[[NestSprite alloc] init:simulation.nest] z:NEST_LAYER tag:NEST_LAYER];

		clouds = [[Clouds alloc] init];
		[self addClouds];

		score = [[Score alloc] init];
		hud = [[HUD alloc] initWithScore:score];
		[self addChild:hud];
	}
	return self;
}

- (void)addClouds {
	for (CCSprite *cloud in [clouds cloudSprites]) {
		[self addChild:cloud z:0];
	}
}

- (void)resetStage {
	[score reset];
	[simulation startLevelOver];
	[[CCDirector sharedDirector] resume];
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
		[simulation redropEgg];
		GameOverLayer *gl = [[GameOverLayer alloc] initWithBouncingEggLayer: self];
		[self addChild: gl z:MENU_LAYER tag:MENU_LAYER_TAG];
		[simulation pause];
	} else {
		[simulation update:dt];
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

- (void)trampolinesRemoved {
	while ([self getChildByTag:TRAMPOLINE_LAYER]) {
		[self removeChildByTag:TRAMPOLINE_LAYER cleanup:true];
	}
}

- (void)unpauseMenu {
	[simulation unpause];
	[self removeChildByTag: MENU_LAYER_TAG cleanup:true];
}

#pragma mark -

- (void)dealloc {
	[super dealloc];
}

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


@end
