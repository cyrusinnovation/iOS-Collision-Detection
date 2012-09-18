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
#import "Wall.h"
#import "WallSprite.h"

#pragma mark - HelloWorldLayer

#define TRAMPOLINE_LAYER 2
#define WALL_LAYER 3
#define STAR_LAYER 4
#define NEST_LAYER 5
#define EGG_LAYER 6
#define MENU_LAYER 100

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

		Level *level = [Levels level2];

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
	[self removeElements:EGG_LAYER];
	[self removeElements:STAR_LAYER];
	[self removeElements:TRAMPOLINE_LAYER];
	[self removeElements:WALL_LAYER];

	simulation = [[Simulation alloc] init:level];
	simulation.observer = self;

	[simulation pause];

	[self addChild:[[EggSprite alloc] init:simulation.egg] z:EGG_LAYER tag:EGG_LAYER];
	[self addChild:[[NestSprite alloc] init:simulation.nest] z:NEST_LAYER tag:NEST_LAYER];

	for (Wall *wall in simulation.walls) {
		[self addChild:[[WallSprite alloc] init:wall] z:WALL_LAYER tag:WALL_LAYER];
	}
}

- (void)removeElements:(int) layer {
	while ([self getChildByTag:layer]) {
		[self removeChildByTag:layer cleanup:true];
	}
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

	[self removeMenu];

	CGSize s = [[CCDirector sharedDirector] winSize];
	PlacingModeMenu *pmm = [[PlacingModeMenu alloc] init:self];
	[pmm setPosition:cgp(s.width - 64, 48)];
	[self addChild:pmm z:MENU_LAYER tag:MENU_LAYER];

	[simulation redropEgg];
	[simulation pause];
}

- (void)enterGameStateDropping {
	gameState = gameStateDropping;

	[self removeMenu];
	[simulation unpause];
}

- (void)removeMenu {
	while ([self getChildByTag:MENU_LAYER]) {
		[self removeChildByTag:MENU_LAYER cleanup:true];
	}
}

- (void)enterGameStateVictoryMenu {
	gameState = gameStateVictoryMenu;

	GameOverLayer *gl = [[GameOverLayer alloc] initWithBouncingEggLayer:self];
	[self addChild:gl z:MENU_LAYER tag:MENU_LAYER];
}

- (void)resetTrampolines {
	[simulation resetTrampolines];
	[[CCDirector sharedDirector] resume];
}

- (void)tryAgain {
	[self enterGameStatePlacing];
}

- (void)nextLevel {
	Level *level = [Levels level2];
	[self initSimulation:level];
	[self enterGameStatePlacing];
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

	[self addChild:newTrampolineSprite z:TRAMPOLINE_LAYER tag:TRAMPOLINE_LAYER];

	return true;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];

	[newTrampoline setFrom:newTrampolineAnchor to:location];
	[newTrampolineSprite update:0];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];

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
