//
// Created by najati on 9/24/12.
//

#import "Walter.h"
#import "NullWalterObserver.h"

typedef enum {
	walterIsRunningLeft,
	walterIsRunningRight
} WalterDirection;

typedef enum {
	walterIsRunning,
	walterIsGroundJumping,
	walterIsOnAWall,
	walterIsWallJumping,
	walterIsFalling,
} WalterAction;

@implementation Walter {
	Stage *stage;
	CGPoint location;
	CGPoint size;
	CGPoint velocity;
	float jumpVelocity;
	int runningSpeed;

	WalterDirection direction;
	WalterAction action;
	int frameCollisionCount;

	bool dead;
	CGPolygon base_polygon;
	CGPolygon local_polygon;
	CGFloat bottom;
	CGFloat top;
	CGFloat left;
	CGFloat right;

	NSObject <WalterObserver> *walterObserver;
}

@synthesize location;
@synthesize dead;
@synthesize bottom;
@synthesize top;
@synthesize left;
@synthesize right;
@synthesize width;

@synthesize walterObserver;

- (BOOL)runningRight {
	return direction == walterIsRunningRight;
}

- (id)initAt:(CGPoint)at {
	self = [super init];
	if (!self) return self;

	self.walterObserver = [NullWalterObserver instance];

	size = cgp(20, 30);
	width = size.x;

	base_polygon = make_block(0, 0, size.x, size.y);
	local_polygon = make_block(0, 0, 0, 0);

	[self updateLocation:at];

	runningSpeed = 500;
	velocity = cgp(runningSpeed, 0);

	jumpVelocity = 700;

	[self updateDirection:walterIsRunningRight];
	[self updateAction:walterIsRunning];
	frameCollisionCount = 0;

	dead = false;

	return self;
}

- (void)updateLocation:(CGPoint)newLocation {
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
	[self updateLocation:cgp_add(location, movement)];

	if ((action == walterIsGroundJumping || action == walterIsWallJumping) && velocity.y < 0) {
		[self updateAction:walterIsFalling];
	} else if (action == walterIsRunning && frameCollisionCount == 0) {
		[self updateAction:walterIsFalling];
	}

	frameCollisionCount = 0;
}

- (void)correct:(CGPoint)delta {
	[self updateLocation:cgp_add(location, delta)];

	CGPoint killer = cgp_project(delta, velocity);
	// only kill y velocity, let it keep moving along x
	// TODO this math needs to be a lot better, e.g. this doesn't handle hitting ceilings
	// TODO also, Walter can't walk up a slope and jump or slide down slopes at all
	killer = cgp_project(cgp(0, -1000), killer);
	velocity = cgp_subtract(velocity, killer);

	if ((action == walterIsGroundJumping || action == walterIsWallJumping || action == walterIsFalling) && delta.y > 0 && velocity.y == 0) {
		[self updateAction:walterIsRunning];
	}

	if (delta.x != 0) {
		[self updateAction:walterIsOnAWall];
	}

	frameCollisionCount++;
}

- (JumpType)jumpLeft {
	bool jumpFromGround = action == walterIsRunning && direction == walterIsRunningLeft;
	bool jumpFromAWall = action == walterIsOnAWall && direction == walterIsRunningRight;

	if (jumpFromGround || jumpFromAWall) {
		velocity = cgp(-runningSpeed, jumpVelocity);

		[self updateDirection:walterIsRunningLeft];

		if (jumpFromGround) {
			[self updateAction:walterIsGroundJumping];
			return groundJump;
		}
		else {
			[self updateAction:walterIsWallJumping];
			return wallJump;
		}
	} else {
		return noJump;
	}
}

- (JumpType)jumpRight {
	bool jumpFromGround = action == walterIsRunning && direction == walterIsRunningRight;
	bool jumpFromAWall = action == walterIsOnAWall && direction == walterIsRunningLeft;

	if (jumpFromGround || jumpFromAWall) {
		velocity = cgp(runningSpeed, jumpVelocity);

		[self updateDirection:walterIsRunningRight];

		if (jumpFromGround) {
			[self updateAction:walterIsGroundJumping];
			return groundJump;
		}
		else {
			[self updateAction:walterIsWallJumping];
			return wallJump;
		}
	} else {
		return noJump;
	}
}

- (void)updateAction:(WalterAction)_action {
	if (action == _action) return;
	action = _action;

	switch (action) {
		case walterIsWallJumping:
			[walterObserver wallJumping];
			break;
		case walterIsGroundJumping:
			[walterObserver groundJumping];
			break;
		case walterIsFalling:
			[walterObserver falling];
			break;
		case walterIsRunning:
			[walterObserver running];
			break;
	}
}

- (void)updateDirection:(WalterDirection)_direction {
	direction = _direction;

	switch (direction) {
		case walterIsRunningLeft:
			[walterObserver runningLeft];
			break;
		case walterIsRunningRight:
			[walterObserver runningRight];
			break;
	}
}

- (void)kill {
	dead = true;
}

@end