//
//  BouncingEggLayer.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


// Import the interfaces
#import "BouncingEggLayer.h"

#import "CGPoint_ops.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "TrampolineSprite.h"
#import "EggSprite.h"

#include <stdlib.h>


#pragma mark - HelloWorldLayer

@implementation BouncingEggLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	BouncingEggLayer *layer = [BouncingEggLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if (self=[super init]){
        CGSize s = [[CCDirector sharedDirector] winSize];
        CCSprite * bg = [CCSprite spriteWithFile:@"eggbackground.png"];
        [bg setPosition:ccp(s.width/2, s.height/2)];
        [self addChild:bg z:0];
        
        clouds = [[Clouds alloc] init];
        [self addClouds];
        
        trampolines = [[NSMutableArray alloc] init];
        
        egg = [[Egg alloc] initAt:160 and:400 withRadius:15];
        
        
        [self addChild:[[EggSprite alloc] init:egg]];
        
        [self scheduleUpdate];
        
        self.isTouchEnabled = YES;
	}
	return self;
}

-(void) addClouds {
    for (CCSprite *cloud in [clouds cloudSprites]) {
        [self addChild:cloud z:0];
    }    
} 

-(void) reset:(CGPoint) location {
    [egg resetTo:location];
    
    for (Trampoline *trampoline in trampolines) {
        [trampoline reset];
    }
}

-(void) resetStage {
    [trampolines removeAllObjects];
    
    while ([self getChildByTag:2]) {
        [self removeChildByTag:2 cleanup:true];
    }
}

-(void) addTrampoline:(Trampoline *) t {
    [trampolines addObject: t];
    [self addChild:[[TrampolineSprite alloc] init:t] z:2];
}

-(void)update:(ccTime)dt {
    [egg update:dt];
    
    if (egg.location.y < -20 || 
        egg.location.x < -20 ||
        egg.location.x > 400) {
        [self reset:cgp(160, 500)];
    }
    else {
        for (Trampoline *trampoline in trampolines) {
            [trampoline handle: egg over:dt];
        }
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    newTrampolineAnchor = cgp_subtract(location, cgp(10, 0));
    newTrampoline = [[Trampoline alloc] initFrom:newTrampolineAnchor to:location];
    newTrampolineSprite = [[TrampolineSprite alloc] init:newTrampoline];
    
    [self addChild:newTrampolineSprite z:3 tag:2];
    
    return true;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    [newTrampoline setFrom:newTrampolineAnchor to:location];
    [newTrampolineSprite update: 0];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    if (location.x < 40 && location.y > 440) {
        newTrampoline = NULL;
        [self resetStage];
        return;
    }
    
    [newTrampoline setFrom:newTrampolineAnchor to:location];
    [newTrampolineSprite update: 0];
    
    [trampolines addObject:newTrampoline];    
    newTrampoline = NULL;
}

- (void) dealloc
{
	[super dealloc];
}

- (void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];    
}


@end
