//
//  MultitouchRotation.m
//  iOSGeometryTools
//
//  Created by Najati Imam on 9/2/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "MultitouchRotation.h"

#include "CGPoint_ops.h"

@implementation MultitouchRotation

-(id) initStartingAt:(float) angle from:(CGPoint) from to:(CGPoint) to {
    if (self = [super init]) {
        initial_angle = angle;
        initial_vector = cgp_subtract(to, from);
        cgp_normalize(&initial_vector);
        
        facing = from.x < to.y;
        
        current_angle = 0;
    }
    return self;
}

-(void) nowFrom:(CGPoint) from to:(CGPoint) to {
    CGPoint current_vector = cgp_subtract(to, from);
//    bool curent_facing = from.x < to.y;
    
    float dot = cgp_dot(initial_vector, current_vector);
    current_angle = acosf(dot);
}

-(float) currentAngle {
    return initial_angle + current_angle;
}


@end
