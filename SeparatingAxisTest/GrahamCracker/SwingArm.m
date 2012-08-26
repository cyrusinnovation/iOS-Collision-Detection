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

-(id)initFrom: (CGPoint) _center to: (CGPoint) end_point {
    if (self == [super init]) {
        center = _center;
        arm_length = cgp_length(cgp_subtract(end_point, _center));
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

-(CGPoint)center {
    return center;
}

@end
