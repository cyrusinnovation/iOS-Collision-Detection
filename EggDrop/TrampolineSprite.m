//
//  TrampolineSprite.m
//  EggDrop
//
//  Created by Najati Imam on 9/11/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "TrampolineSprite.h"

#include "CGPoint_ops.h"

@implementation TrampolineSprite

- (id)init:(Trampoline *)t {
	if (self = [super init]) {
		trampoline = t;

		ccTexParams params = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};

		left = [[CCSprite alloc] initWithFile:@"rope.png" rect:CGRectMake(0, 0, 8, 0)];
		right = [[CCSprite alloc] initWithFile:@"rope.png" rect:CGRectMake(0, 0, 8, 0)];
		leftKnob = [[CCSprite alloc] initWithFile:@"knob.png"];
		rightKnob = [[CCSprite alloc] initWithFile:@"knob.png"];

		[[left texture] setTexParameters:&params];
		[[right texture] setTexParameters:&params];

		[self addChild:left];
		[self addChild:right];
		[self addChild:leftKnob];
		[self addChild:rightKnob];

		[self update:0];

		[self scheduleUpdate];
	}
	return self;
}

- (void)update:(ccTime)dt {
	[left setTextureRect:CGRectMake(0, 0, 8, [trampoline left_width])];
	[left setPosition:[trampoline left_center]];
	[left setRotation:[trampoline left_angle]];

	[right setTextureRect:CGRectMake(0, 0, 8, [trampoline right_width])];
	[right setPosition:[trampoline right_center]];
	[right setRotation:[trampoline right_angle]];

	[leftKnob setPosition:[trampoline left]];
	[rightKnob setPosition:[trampoline right]];
}

@end
