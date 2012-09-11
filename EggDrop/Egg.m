//
//  Egg.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Egg.h"

#include "CGPoint_ops.h"

#import "WorldConstants.h"

@implementation Egg

@synthesize radius;
@synthesize location;

-(id) initAt:(float) _x and:(float) _y withRadius:(float) _radius {
    if (self = [super init]) {
        radius = _radius;
        location = cgp(_x, _y);
        
        terminalVelocity = 10;
        terminalVelocitySquared = terminalVelocity*terminalVelocity;
    }
    return self;
}


-(void)update:(ccTime)dt {
    velocity = cgp_add(velocity, cgp_times([WorldConstants gravity], dt));
    if (cgp_length_squared(velocity) > terminalVelocitySquared) {
        cgp_normalize(&velocity);
        cgp_scale(&velocity, terminalVelocity);
    }
    
    location = cgp_add(location, velocity);
}

-(void) bounce:(float) rate {
    velocity.y = -velocity.y * rate;
}

-(void) move:(CGPoint) delta {
    location = cgp_add(location, delta);
}


@end
