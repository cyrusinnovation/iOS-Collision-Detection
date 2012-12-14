//
// Created by najati on 9/24/12.
//

#import "Walter.h"

typedef enum {
	stateRunningLeft,
	stateRunningRight
} GuyState;

@implementation Walter {
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
	CGPolygon base_polygon;
	CGPolygon local_polygon;
	CGFloat bottom;
	CGFloat top;
	CGFloat left;
	CGFloat right;
}

@synthesize location;
@synthesize dead;
@synthesize bottom;
@synthesize top;
@synthesize left;
@synthesize right;


- (BOOL)runningRight {
	return state == stateRunningRight;
}

- (id)initAt:(CGPoint)at {
	if (self = [super init]) {
		size = cgp(20, 30);

		base_polygon = make_block(0, 0, size.x, size.y);
		local_polygon = make_block(0, 0, 0, 0);

		[self updateLocation:at];

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

-(void) updateLocation:(CGPoint) newLocation {
	location = newLocation;
	CGPoint delta = location;
	transform_polygon(base_polygon, delta, local_polygon);

	bottom = newLocation.y;
	top = newLocation.y + size.y;
	left = newLocation.x;
	right = newLocation.x + size.x;
}

- (CGPolygon)polygon {
	return local_polygon;
}

- (void)update:(ccTime)dt {
	CGPoint frame_velocity = cgp_times([WorldConstants gravity], dt);
	velocity = cgp_add(velocity, frame_velocity);

	CGPoint movement = cgp_times(velocity, dt);
	[self updateLocation: cgp_add(location, movement)];

	inTheAir = true;
	onAWall = false;
}

- (void)correct:(CGPoint)delta {
	[self updateLocation:cgp_add(location, delta)];

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

- (JumpType)jumpLeft {
	bool jumpFromGround = !inTheAir && !onAWall && state == stateRunningLeft;
	bool jumpFromAWall = inTheAir && onAWall && state == stateRunningRight;

	if (jumpFromGround || jumpFromAWall) {
		velocity = cgp(-runningSpeed, jumpVelocity);
		state = stateRunningLeft;

		if (jumpFromGround) return groundJump;
		else return wallJump;
	} else {
		return noJump;
	}
}

- (JumpType)jumpRight {
	bool jumpFromGround = !inTheAir && !onAWall && state == stateRunningRight;
	bool jumpFromAWall = inTheAir && onAWall && state == stateRunningLeft;

	if (jumpFromGround || jumpFromAWall) {
		velocity = cgp(runningSpeed, jumpVelocity);
		state = stateRunningRight;

		if (jumpFromGround) return groundJump;
		else return wallJump;
	} else {
		return noJump;
	}
}

- (void)kill {
	dead = true;
}

@end