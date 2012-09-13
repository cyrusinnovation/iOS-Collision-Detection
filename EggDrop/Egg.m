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
        
        terminalVelocity = [WorldConstants terminalVelocity];
        terminalVelocitySquared = terminalVelocity*terminalVelocity;
    }
    return self;
}

-(CGPoint)velocity {
    return velocity;
}

-(void)update:(ccTime)dt {
    CGPoint gravity = cgp_times([WorldConstants gravity], dt);
    velocity = cgp_add(velocity, gravity);
    

    if (cgp_length_squared(velocity) > terminalVelocitySquared) {
        cgp_normalize(&velocity);
        cgp_scale(&velocity, terminalVelocity);
    }
    
    CGPoint delta = cgp_times(velocity, dt);
    location = cgp_add(location, delta);
}

-(void) bounce:(float) rate {
    velocity.y = -velocity.y * rate;
}

-(CGPoint) slow:(CGPoint) factor {
    CGPoint old_vel = velocity;
    velocity = cgp(velocity.x*(1 - factor.x), velocity.y*(1 - factor.y));
    return cgp_subtract(old_vel, velocity);
}

-(void) move:(CGPoint) delta {
    location = cgp_add(location, delta);
}

-(void) resetTo:(CGPoint) _location {
    location = _location;
    velocity = cgp(0, 0);
}

-(void) boost:(CGPoint) rate during:(float) dt {
    velocity = cgp_add(velocity, cgp_times(rate, dt)) ;
}


@end
