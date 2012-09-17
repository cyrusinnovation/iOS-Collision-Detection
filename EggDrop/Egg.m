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

@implementation Egg {
	CGPoint force;
}

@synthesize radius;
@synthesize location;

- (id)initAt:(float)_x and:(float)_y withRadius:(float)_radius {
	if (self = [super init]) {
		radius = _radius;
		location = cgp(_x, _y);

		terminalVelocity = [WorldConstants terminalVelocity];
		terminalVelocitySquared = terminalVelocity * terminalVelocity;
	}
	return self;
}

- (CGPoint)velocity {
	return velocity;
}

- (void)update:(ccTime)dt {
	CGPoint totalForce = cgp_add([WorldConstants gravity], force);
	CGPoint frame_velocity = cgp_times(totalForce, dt);
	velocity = cgp_add(velocity, frame_velocity);

	if (cgp_length_squared(velocity) > terminalVelocitySquared) {
		cgp_normalize(&velocity);
		cgp_scale(&velocity, terminalVelocity);
	}

	CGPoint movement = cgp_times(velocity, dt);
	location = cgp_add(location, movement);
}

- (void)resetTo:(CGPoint)_location {
	location = _location;
	velocity = cgp(0, 0);
}

- (void) resetForce {
	force = cgp(0, 0);
}

- (void) applyForce:(CGPoint)f {
	force = cgp_add(force, f);
}

@end
