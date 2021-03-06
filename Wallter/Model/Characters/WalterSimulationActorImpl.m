//
// Created by najati on 9/24/12.
//

#import "WalterSimulationActorImpl.h"
#import "BadGuy.h"

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

@implementation WalterSimulationActorImpl {
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
}

@synthesize location;

@synthesize top;
@synthesize bottom;
@synthesize left;
@synthesize right;

@synthesize width;

@synthesize observer;

- (id)initAt:(CGPoint)at {
	self = [super init];
	if (!self) return self;

	observer = (ProxyCollection<WalterObserver> *) [[ProxyCollection alloc] init];

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

- (BOOL)facingRight {
	return direction == walterIsRunningRight;
}

- (void)updateLocation:(CGPoint)newLocation {
	location = newLocation;
	transform_polygon(base_polygon, location, local_polygon);

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
	} else if ((action == walterIsRunning || action == walterIsOnAWall) && frameCollisionCount == 0) {
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

-(void) logActionName {
	switch (action) {
		case walterIsRunning:
			NSLog(@"running");
			break;
		case walterIsGroundJumping:
			NSLog(@"ground jump");
			break;
		case walterIsOnAWall:
			NSLog(@"on a wall");
			break;
		case walterIsWallJumping:
			NSLog(@"wall jump");
			break;
		case walterIsFalling:
			NSLog(@"falling");
			break;
	}
}

- (void)updateAction:(WalterAction)_action {
	if (action == _action) return;
	action = _action;

	switch (action) {
		case walterIsRunning:
			[observer running];
			break;
		case walterIsGroundJumping:
			[observer groundJumping];
			break;
		case walterIsOnAWall:
			break;
		case walterIsWallJumping:
			[observer wallJumping];
			break;
		case walterIsFalling:
			[observer falling];
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