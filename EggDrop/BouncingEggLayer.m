//
//  BouncingEggLayer.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


#import "SimulationObserver.h"
#import "BouncingEggLayer.h"

#import "EggSprite.h"
#import "NestSprite.h"
#import "HUD.h"
#import "StarSprite.h"
#import "Simulation.h"
#import "Level.h"
#import "Levels.h"
#import "GameOverLayer.h"
#import "PlacingModeMenu.h"
#import "CGPoint_ops.h"

#pragma mark - HelloWorldLayer

#define TRAMPOLINE_LAYER 2
#define EGG_LAYER 3
#define NEST_LAYER 3
#define STAR_LAYER 4
#define MENU_LAYER 100

#define MENU_LAYER_TAG 100

typedef enum {
	gameStatePlacing,
	gameStateDropping,
	gameStateVictoryMenu
} GameState;

@implementation BouncingEggLayer {
	Simulation *simulation;

	ccTime buffer;
	ccTime frameTime;

	HUD *hud;

	GameState gameState;
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

		buffer = 0;
		frameTime = 0.01;

		Level *level = [Levels level1];

		[self initBackground];
		[self initSimulation:level];
		[self initClouds];
		[self initHud];

		[self enterGameStatePlacing];
	}
	return self;
}

- (void)initBackground {
	CGSize s = [[CCDirector sharedDirector] winSize];
	CCSprite *bg = [CCSprite spriteWithFile:@"eggbackground.png"];
	[bg setPosition:ccp(s.width / 2, s.height / 2)];
	[self addChild:bg z:0];
}

- (void)initSimulation:(Level *)level {
	simulation = [[Simulation alloc] init:level];
	simulation.observer = self;

	[simulation pause];
	[simulation startLevelOver];

	[self addChild:[[EggSprite alloc] init:simulation.egg] z:EGG_LAYER tag:EGG_LAYER];
	[self addChild:[[NestSprite alloc] init:simulation.nest] z:NEST_LAYER tag:NEST_LAYER];
}

- (void)initClouds {
	clouds = [[Clouds alloc] init];
	for (CCSprite *cloud in [clouds cloudSprites]) {
		[self addChild:cloud z:0];
	}
}

- (void)initHud {
	score = [[Score alloc] init];
	hud = [[HUD alloc] initWithScore:score];
	[self addChild:hud];
}

#pragma mark state transitions

- (void)enterGameStatePlacing {
	gameState = gameStatePlacing;

	CGSize s = [[CCDirector sharedDirector] winSize];

	PlacingModeMenu *pmm = [[PlacingModeMenu alloc] init:self];
	[pmm setPosition:cgp(s.width - 32, 32)];
	[self addChild:pmm z:MENU_LAYER tag:MENU_LAYER_TAG];

	[simulation pause];
}

- (void)enterGameStateDropping {
	gameState = gameStateDropping;

	while ([self getChildByTag:MENU_LAYER_TAG]) {
		[self removeChildByTag:MENU_LAYER_TAG cleanup:true];
	}
	[simulation unpause];
}

- (void)enterGameStateVictoryMenu {
	gameState = gameStateVictoryMenu;

	GameOverLayer *gl = [[GameOverLayer alloc] initWithBouncingEggLayer:self];
	[self addChild:gl z:MENU_LAYER tag:MENU_LAYER_TAG];
}

- (void)resetStage {
	[score reset];
	[simulation startLevelOver];
	[[CCDirector sharedDirector] resume];
}

- (void)tryAgain {
	[simulation unpause];
	[self removeChildByTag:MENU_LAYER_TAG cleanup:true];
}


#pragma mark update

- (void)update:(ccTime)dt {
	buffer += dt;
	while (buffer >= frameTime) {
		buffer -= frameTime;
		[self updateInternal:frameTime];
	}
}

- (void)updateInternal:(ccTime)dt {
	if (gameState == gameStateDropping) {
		[simulation update:dt];
	}
}

#pragma mark Touch methods

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

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
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

- (void)eggDied {
	[score adjustBy:1];
	[simulation redropEgg];
	[simulation pause];

	[self enterGameStatePlacing];
}

- (void)eggHitNest {
	[self enterGameStateVictoryMenu];
}


- (void)newTrampoline:(Trampoline *)trampoline {
	[self addChild:[[TrampolineSprite alloc] init:trampoline] z:TRAMPOLINE_LAYER tag:TRAMPOLINE_LAYER];
}

- (void)trampolinesRemoved {
	while ([self getChildByTag:TRAMPOLINE_LAYER]) {
		[self removeChildByTag:TRAMPOLINE_LAYER cleanup:true];
	}
}

#pragma mark -

- (void)dealloc {
	[super dealloc];
}

@end
