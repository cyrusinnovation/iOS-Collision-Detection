//
// Created by najati on 9/24/12.
//

#import "Guy.h"

typedef enum {
	stateRunningLeft,
	stateRunningRight
} GuyState;

@implementation Guy {
	Stage *stage;
	CGPoint location;
	CGPoint size;
	CGPoint velocity;
	float jumpVelocity;
	bool inTheAir;
	bool onAWall;
	int runningSpeed;
	GuyState state;
	bool dead;
}

@synthesize location;
@synthesize dead;


- (BOOL)runningRight {
	return state == stateRunningRight;
}

- (id)initAt:(CGPoint)at {
	if (self = [super init]) {
		location = at;
		size = cgp(20, 30);

		runningSpeed = 500;
		velocity = cgp(runningSpeed, 0);

		jumpVelocity = 700;

		inTheAir = false;
		onAWall = false;

		state = stateRunningRight;

		dead = false;
	}
	return self;
}

- (void)resetTo:(CGPoint)_location {
	location = _location;
	velocity = cgp(runningSpeed, 0);
}

- (CGPolygon)polygon {
	// TODO hahah huge memory leak
	return make_block(location.x, location.y, location.x + size.x, location.y + size.y);
}

- (void)update:(ccTime)dt {
	CGPoint frame_velocity = cgp_times([WorldConstants gravity], dt);
	velocity = cgp_add(velocity, frame_velocity);

	CGPoint movement = cgp_times(velocity, dt);
	location = cgp_add(location, movement);

	inTheAir = true;
	onAWall = false;
}

int tick = 0;

- (void)correct:(CGPoint)delta {
	location = cgp_add(location, delta);

	CGPoint killer = cgp_project(delta, velocity);
	// only kill y velocity, let it keep moving along x
	// TODO this math needs to be a lot better, e.g. this doesn't handle hitting ceilings
	// TODO also, Wallter can't walk up a slope and jump or slide down slopes at all
	killer = cgp_project(cgp(0, -1000), killer);
	velocity = cgp_subtract(velocity, killer);

	if (inTheAir && delta.y > 0 && velocity.y == 0) {
		inTheAir = false;
	}

	if (delta.x != 0) {
		onAWall = true;
	}
}

//- (void)jump {
//	if (inTheAir) return;
//
//	inTheAir = true;
//	velocity = cgp_add(velocity, cgp(0, jumpVelocity));
//}

- (void)jumpLeft {
	bool jumpFromGround = !inTheAir && !onAWall && state == stateRunningLeft;
	bool jumpFromAWall = inTheAir && onAWall && state == stateRunningRight;

	if (jumpFromGround || jumpFromAWall) {
		velocity = cgp(-runningSpeed, jumpVelocity);
		state = stateRunningLeft;
	}
}

- (void)jumpRight {
	bool jumpFromGround = !inTheAir && !onAWall && state == stateRunningRight;
	bool jumpFromAWall = inTheAir && onAWall && state == stateRunningLeft;

	if (jumpFromGround || jumpFromAWall) {
		velocity = cgp(runningSpeed, jumpVelocity);
		state = stateRunningRight;
	}
}

- (void)kill {
	dead = true;
}

@end