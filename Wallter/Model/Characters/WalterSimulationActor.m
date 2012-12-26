//
// Created by najati on 9/24/12.
//

#import "WalterSimulationActor.h"
#import "AggregateWalterObserver.h"
#import "BadGuy.h"
#import "Platform.h"
#import "MeleeAttack.h"

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

@implementation WalterSimulationActor {
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

	NSObject <WalterObserver> *observer;
}

@synthesize location;

@synthesize top;
@synthesize bottom;
@synthesize left;
@synthesize right;

@synthesize width;

@synthesize observer;

- (BOOL)runningRight {
	return direction == walterIsRunningRight;
}

- (id)initAt:(CGPoint)at {
	self = [super init];
	if (!self) return self;

	self.observer = [[AggregateWalterObserver alloc] init];

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

- (JumpType)jump {
	JumpType jump = noJump;

	if (action == walterIsRunning) {
		if (direction == walterIsRunningRight) {
			velocity = cgp(runningSpeed, jumpVelocity);
		} else {
			velocity = cgp(-runningSpeed, jumpVelocity);
		}

		[self updateAction:walterIsGroundJumping];

		jump = groundJump;
	} else if (action == walterIsOnAWall) {
		if (direction == walterIsRunningRight) {
			velocity = cgp(-runningSpeed, jumpVelocity);
			[self updateDirection:walterIsRunningLeft];
		} else {
			velocity = cgp(runningSpeed, jumpVelocity);
			[self updateDirection:walterIsRunningRight];
		}

		[self updateAction:walterIsWallJumping];

		jump = wallJump;
	}

	return jump;
}

- (void)updateAction:(WalterAction)_action {
	if (action == _action) return;
	action = _action;

	switch (action) {
		case walterIsWallJumping:
			[observer wallJumping];
			break;
		case walterIsGroundJumping:
			[observer groundJumping];
			break;
		case walterIsFalling:
			[observer falling];
			break;
		case walterIsRunning:
			[observer running];
			break;
		case walterIsOnAWall:
			break;
	}
}

- (void)updateDirection:(WalterDirection)_direction {
	direction = _direction;

	switch (direction) {
		case walterIsRunningLeft:
			[observer runningLeft];
			break;
		case walterIsRunningRight:
			[observer runningRight];
			break;
	}
}

- (BOOL)expired {
	return dead;
}

- (void)collides:(SATResult)result with:(id <BoundedPolygon>)that {
	if ([that isMemberOfClass:[Platform class]]) {
		[self correct:result.penetration];
	} else if ([that isMemberOfClass:[BadGuy class]]) {
		[self kill];
	}
}

- (void)kill {
	dead = true;
	[observer dying];
}

@end