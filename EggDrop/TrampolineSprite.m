//
//  TrampolineSprite.m
//  EggDrop
//
//  Created by Najati Imam on 9/11/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "TrampolineSprite.h"

@interface TrampolineSprite() {
    CCAction *fadeAndDieAction_;
}
-(void) fadeAndDie;
-(void) die;
-(void) setOpacity:(GLubyte)op;
@end

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
    if(trampoline.isExhausted) {
        [self fadeAndDie];
        return;
    }
	[left setTextureRect:CGRectMake(0, 0, 8, [trampoline left_length])];
	[left setPosition:[trampoline left_center]];
	[left setRotation:[trampoline left_angle]];

	[right setTextureRect:CGRectMake(0, 0, 8, [trampoline right_length])];
	[right setPosition:[trampoline right_center]];
	[right setRotation:[trampoline right_angle]];

	[leftKnob setPosition:[trampoline left]];
	[rightKnob setPosition:[trampoline right]];
}

- (void)fadeAndDie {
    if (fadeAndDieAction_) return;

    id fadeOut = [CCFadeOut actionWithDuration:0.3f];
    id death = [CCCallFunc actionWithTarget:self selector:@selector(die)];
    fadeAndDieAction_ = [CCSequence actions:fadeOut, death, nil];
    [self runAction:fadeAndDieAction_];
}

- (void) die {
    [left      removeFromParentAndCleanup:YES];
    [leftKnob  removeFromParentAndCleanup:YES];
    [right     removeFromParentAndCleanup:YES];
    [rightKnob removeFromParentAndCleanup:YES];
    [self removeFromParentAndCleanup:YES];
}

- (void)setOpacity:(GLubyte)op {
    [left      setOpacity:op];
    [leftKnob  setOpacity:op];
    [right     setOpacity:op];
    [rightKnob setOpacity:op];
}

@end
