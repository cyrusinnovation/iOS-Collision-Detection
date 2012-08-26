//
//  SwingArm.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 8/25/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "SwingArm.h"

#include "math.h"

#include "CGPoint_ops.h"

@implementation SwingArm

-(id)initAt: (CGPoint) location withLength: (float) _arm_length
{
    if (self == [super init]) {
        center = CGPointMake(location.x - _arm_length, location.y);
        arm_length = _arm_length;
        [self update:0];
    }
    return self;
}

const float two_pi = 2*M_PI;

-(void)update:(ccTime)dt {
    age += dt;
    if (age > 1) {
        age -= 1;
    }
    
    float rad = age*two_pi;
    arm.x = cosf(rad)*arm_length;
    arm.y = sinf(rad)*arm_length;
}

-(CGPoint)endOfArm {
    return cgp_add(center, arm);
}

@end
