//
//  BouncingEggLayer.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


#import "BouncingEggLayer.h"

#import "CGPoint_ops.h"

#import "EggSprite.h"
#import "NestSprite.h"
#import "HUD.h"
#import "StarSprite.h"

#pragma mark - HelloWorldLayer

@implementation BouncingEggLayer {
	HUD *hud;
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

		trampolines = [[NSMutableArray alloc] init];
		[self addTrampoline:[[Trampoline alloc] initFrom:cgp(40, 400) to:cgp(280, 400)]];

		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *bg = [CCSprite spriteWithFile:@"eggbackground.png"];
		[bg setPosition:ccp(s.width / 2, s.height / 2)];
		[self addChild:bg z:0];

		clouds = [[Clouds alloc] init];
		[self addClouds];

		trampolines = [[NSMutableArray alloc] init];
		stars = [[NSMutableArray alloc] init];
		[self addStars];

		egg = [[Egg alloc] initAt:s.width / 2 and:s.height withRadius:15];
		[self addChild:[[EggSprite alloc] init:egg] z:3];

		nest = [[Nest alloc] initAt:s.width / 4 and:60];
		[self addChild:[[NestSprite alloc] init:nest]];

		score = [[Score alloc] init];
		hud = [[HUD alloc] initWithScore:score];
		[self addChild:hud];

	}
	return self;
}

- (void)addStars {
	for (StarSprite *starSprite in stars)
		[self removeChild:starSprite cleanup:true];

	[stars removeAllObjects];

	CGSize s = [[CCDirector sharedDirector] winSize];
	Star *star = [[Star alloc] initAt:s.width * 0.25 and:s.height * 0.75];
	[stars addObject:[[StarSprite alloc] init:star]];

	star = [[Star alloc] initAt:s.width * 0.75 and:s.height * 0.5];
	[stars addObject:[[StarSprite alloc] init:star]];

	star = [[Star alloc] initAt:s.width * 0.35 and:s.height * 0.3];
	[stars addObject:[[StarSprite alloc] init:star]];

	for (StarSprite *star in stars)
		[self addChild:star];
}

- (void)addClouds {
	for (CCSprite *cloud in [clouds cloudSprites]) {
		[self addChild:cloud z:0];
	}
}

- (void)reset:(CGPoint)location {
	[egg resetTo:location];
	[self addStars];

	for (Trampoline *trampoline in trampolines) {
		[trampoline reset];
	}
}

- (void)resetCloud:(CCSprite *)cloud {
	float scale = (float) (arc4random() % 100) / 100.0 + 0.5;
	cloud.scale = scale;
	int x = ((int) -[cloud boundingBox].size.width);

	[self setCloud:cloud scale:scale at:x];
}

- (void)resetCloud:(CCSprite *)cloud at:(int)x {
	float scale = (float) (arc4random() % 100) / 100.0 + 0.5;
	cloud.scale = scale;

	[self setCloud:cloud scale:scale at:x];
}

- (void)setCloud:(CCSprite *)cloud scale:(float)scale at:(int)x {
	CGSize s = [[CCDirector sharedDirector] winSize];
	int y = arc4random() % (int) s.height;
	[cloud setPosition:ccp(x, y)];

	CCMoveBy *move = [CCMoveTo actionWithDuration:40 / scale position:ccp(s.width + [cloud boundingBox].size.width / 2, y)];
	CCCallFuncN *func = [CCCallFuncN actionWithTarget:self selector:@selector(resetCloud:)];
	[cloud runAction:[CCSequence actions:move, func, nil]];
}

- (void)resetStage {
	[[CCDirector sharedDirector] resume];
	CGSize s = [[CCDirector sharedDirector] winSize];
	[egg resetTo:ccp(s.width / 2, s.height + 100)];
	[trampolines removeAllObjects];

	[score reset];
	[self addStars];

	while ([self getChildByTag:2]) {
		[self removeChildByTag:2 cleanup:true];
	}
}

- (void)addTrampoline:(Trampoline *)t {
	[trampolines addObject:t];
	[self addChild:[[TrampolineSprite alloc] init:t] z:2];
}

- (void)update:(ccTime)dt {
	if (dt <= 0) return;

	[egg update:dt];

	CGSize s = [[CCDirector sharedDirector] winSize];
	if (egg.location.y < -20 ||
			egg.location.x < -20 ||
			egg.location.x > s.width + 30) {
		[score adjustBy:1];
		[self reset:cgp(s.width / 2, s.height + 100)];
	}
	else {
		for (Trampoline *trampoline in trampolines) {
			[trampoline consider:egg];
		}
		for (Trampoline *trampoline in trampolines) {
			[trampoline update:dt];
		}
		[nest handle:egg];

		for (StarSprite *starSprite in stars)
			if ([[starSprite star] doesCollide:egg])
				[self removeChild:starSprite cleanup:true];
	}
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	newTrampolineAnchor = cgp_subtract(location, cgp(10, 0));
	newTrampoline = [[Trampoline alloc] initFrom:newTrampolineAnchor to:location];
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

	[newTrampoline setFrom:newTrampolineAnchor to:location];
	[newTrampolineSprite update:0];

	[trampolines addObject:newTrampoline];
	newTrampoline = NULL;
}

- (void)dealloc {
	[super dealloc];
}

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


@end
