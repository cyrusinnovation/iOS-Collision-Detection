//
//  GameOverLayer.m
//  EggDrop
//
//  Created by CubbyCooker on 9/10/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


#import "GameOverLayer.h"

#include <ccTypes.h>

@implementation GameOverLayer

@synthesize menu;

- (void)dealloc {
	[self removeChild: menu cleanup:true];
	[super dealloc];
}

- (id)initWithBouncingEggLayer: (CCLayer*) bouncingEggLayer {
	if (self = [super initWithColor:ccc4(30, 30, 30, 180)]) {
		self.isTouchEnabled = YES;
		CCMenuItemFont *tryAgain = [CCMenuItemFont itemWithString: @"Try Again" target:bouncingEggLayer selector:@selector(tryAgain)];
		CCMenuItemFont *nextLevel = [CCMenuItemFont itemWithString: @"Next Level" target:bouncingEggLayer selector:@selector(nextLevel)];

		menu = [CCMenu menuWithItems:tryAgain, nextLevel, nil];
		[menu alignItemsVertically];
		[self addChild: menu];
	}
	return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return true;
}

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


@end
