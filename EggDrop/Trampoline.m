//
//  Trampoline.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Trampoline.h"

#include "math.h"
#include "CGPoint_ops.h"

@implementation Trampoline

@synthesize left;
@synthesize right;

-(id)initFrom:(CGPoint) _left to:(CGPoint) _right {
    if (self = [super init]) {
        maxDepth = 10;
        
        self.left = _left;
        self.right = _right;
        
        normal = cgp_subtract(_right, _left);
        cgp_normalize(&normal);
        cgp_flop(&normal);
        
        stored = cgp(0,0);
    }
    return self;
}

float pointToLineDistance(CGPoint A, CGPoint B, CGPoint P)
{
    double normalLength = hypotf(B.x - A.x, B.y - A.y);
    return fabsf((P.x - A.x) * (B.y - A.y) - (P.y - A.y) * (B.x - A.x)) / normalLength;
}

// TODO I think since we're computing cgp_t below we might be able to tighten up the math in here
-(float) eggPenetration: (Egg *) egg {
    return pointToLineDistance(self.left, self.right, egg.location) - egg.radius;
}

-(void) handle:(Egg *) egg {
    float t = cgp_t(self.left, self.right, egg.location);
    if (t < 0 || t > 1) {
        return;
    }
    
    float distance = [self eggPenetration:egg];
    if (distance >= 0) return;
    
    CGPoint projected_velocity = cgp_project(normal, egg.velocity);
    stored = cgp_add(stored, projected_velocity);
    cgp_scale(&projected_velocity, -0.75);
    [egg boost:projected_velocity];
    
    float brake_vel_sqr = cgp_length_squared(projected_velocity);

    if (brake_vel_sqr < 0.1) {
        CGPoint correction = normal;
        cgp_scale(&correction, -distance);
        [egg move: correction];

        CGPoint boost = stored;
        cgp_scale(&boost, -0.5);
        [egg boost: boost];
        stored = cgp(0, 0);
    }
}

-(void) reset {
    stored = cgp(0, 0);
}

@end
