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

		// TODO duped from TrampolineSprite
		CGPoint normal = cgp_subtract(trampoline.right, trampoline.left);
		cgp_normalize(&normal);
		cgp_flop(&normal);

		correction = normal;
		cgp_scale(&correction, -4);

		ccTexParams params = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};

		left = [[CCSprite alloc] initWithFile:@"rope.png" rect:CGRectMake(0, 0, 8, [t left_width])];
		[[left texture] setTexParameters:&params];
		[left setPosition:cgp_add(correction, [t left_center])];
		[left setRotation:[t left_angle]];
		[self addChild:left];

		right = [[CCSprite alloc] initWithFile:@"rope.png" rect:CGRectMake(0, 0, 8, [t right_width])];
		[[right texture] setTexParameters:&params];
		[right setPosition:cgp_add(correction, [t right_center])];
		[right setRotation:[t right_angle]];
		[self addChild:right];

		leftKnob = [[CCSprite alloc] initWithFile:@"knob.png"];
		[leftKnob setPosition:cgp_add(correction, [t left])];
		[self addChild:leftKnob];

		rightKnob = [[CCSprite alloc] initWithFile:@"knob.png"];
		[rightKnob setPosition:cgp_add(correction, [t right])];
		[self addChild:rightKnob];

		[self scheduleUpdate];
	}
	return self;
}

- (void)update:(ccTime)dt {
	[left setTextureRect:CGRectMake(0, 0, 8, [trampoline left_width])];
	[left setPosition:cgp_add(correction, [trampoline left_center])];
	[left setRotation:[trampoline left_angle]];

	[right setTextureRect:CGRectMake(0, 0, 8, [trampoline right_width])];
	[right setPosition:cgp_add(correction, [trampoline right_center])];
	[right setRotation:[trampoline right_angle]];

	[leftKnob setPosition:cgp_add(correction, [trampoline left])];
	[rightKnob setPosition:cgp_add(correction, [trampoline right])];
}

@end
