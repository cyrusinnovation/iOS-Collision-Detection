//
// Created by najati on 9/24/12.
//

#import "Guy.h"

@implementation Guy {
	Stage *stage;
	CGPoint location;
	CGPoint size;
	CGPoint velocity;
}

@synthesize location;

- (id)initIn:(Stage *)_stage at:(CGPoint)at {
	if (self = [super init]) {
		stage = _stage;
		location = at;
		size = cgp(10, 10);

		velocity = cgp(300, 0);
	}
	return self;
}

- (CGPolygon)polygon {
	return make_block(location.x, location.y, location.x + size.y, location.y + size.y);
}

- (void)update:(ccTime)dt {
	CGPoint totalForce = [WorldConstants gravity];
	CGPoint frame_velocity = cgp_times(totalForce, dt);
	velocity = cgp_add(velocity, frame_velocity);

//	if (cgp_length_squared(velocity) > terminalVelocitySquared) {
//		cgp_normalize(&velocity);
//		cgp_scale(&velocity, terminalVelocity);
//	}

	CGPoint movement = cgp_times(velocity, dt);
	location = cgp_add(location, movement);
}

- (void)correct:(CGPoint)delta {
	location = cgp_add(location, delta);
	CGPoint killer = cgp_project(delta, velocity);
	velocity = cgp_subtract(velocity, killer);
}

@end