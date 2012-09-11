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
    }
    return self;
}

float pointToLineDistance(CGPoint A, CGPoint B, CGPoint P)
{
    double normalLength = hypotf(B.x - A.x, B.y - A.y);
    return fabsf((P.x - A.x) * (B.y - A.y) - (P.y - A.y) * (B.x - A.x)) / normalLength;
}

-(float) eggPenetration: (Egg *) egg {
    return pointToLineDistance(self.left, self.right, egg.location) - egg.radius;
}

-(void) handle:(Egg *) egg {
    float distance = [self eggPenetration:egg];
    if (distance < 0) {
        CGPoint correction = normal;
        cgp_scale(&correction, -distance);
        [egg move: correction];
        [egg bounce: 0.9];
    }
}

@end
