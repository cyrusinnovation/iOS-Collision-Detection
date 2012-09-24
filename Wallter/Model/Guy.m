//
// Created by najati on 9/24/12.
//

#import "Guy.h"

@implementation Guy {
	Stage *stage;
	CGPoint location;
	CGPoint size;
	CGPoint velocity;
	float jumpVelocity;
	bool inTheAir;
}

@synthesize location;
@synthesize velocity;

- (id)initIn:(Stage *)_stage at:(CGPoint)at {
	if (self = [super init]) {
		stage = _stage;
		location = at;
		size = cgp(20, 30);

		velocity = cgp(500, 0);

		jumpVelocity = 700;

		inTheAir = false;
	}
	return self;
}

-(void) resetTo:(CGPoint) _location {
	location = _location;
	velocity = cgp(500, 0);
}

- (CGPolygon)polygon {
	return make_block(location.x, location.y, location.x + size.x, location.y + size.y);
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

	inTheAir = true;
}

- (void)correct:(CGPoint)delta {
	location = cgp_add(location, delta);
	CGPoint killer = cgp_project(delta, velocity);
	velocity = cgp_subtract(velocity, killer);

	if (inTheAir && delta.y > 0 && velocity.y == 0) {
		inTheAir = false;
	}
}

- (void)jump {
	if (inTheAir) return;

	inTheAir = true;
	velocity = cgp_add(velocity, cgp(0, jumpVelocity));
}

@end