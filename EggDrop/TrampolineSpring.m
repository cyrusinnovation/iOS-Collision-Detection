#import "TrampolineSpring.h"
#import "Trampoline.h"

#import "CGPoint_ops.h"

@implementation TrampolineSpring {
	Egg *egg;
	Trampoline *trampoline;

	bool alive;
	float spring_constant;
	float damping;
	float gamma;
}

@synthesize trampoline;
@synthesize egg;
@synthesize alive;

- (id)initFor:(Trampoline *)_trampoline and:(Egg *)_egg {
	if (self = [super init]) {
		trampoline = _trampoline;
		egg = _egg;
		alive = true;
		
		spring_constant = 10000;
		damping = 2;

		gamma = 0.5 * sqrtf(4 * spring_constant - damping * damping);
		assert(gamma != 0);
	}
	return self;
}

- (void)update:(ccTime)dt {
	if (!alive) {
		return;
	}

	float penetration = [trampoline eggPenetration:egg];
	float t = cgp_t(trampoline.left, trampoline.right, egg.location);

	if (penetration < 0 || t < 0 || t > 1) {
		alive = false;
		return;
	}

	CGPoint position = cgp_add(egg.location, cgp_times(trampoline.normal, -(egg.radius)));
	CGPoint anchor = cgp_add(trampoline.left, cgp_times(cgp_subtract(trampoline.right, trampoline.left), t));
	position = cgp_subtract(position, anchor);

	CGPoint fake_spring_force = [self fake_spring:position dt:dt];
	CGPoint simple_spring_force = [self simpleSpringForce:penetration];

	[egg applyForce:fake_spring_force];

//	NSLog(@"fake spring %f %f", fake_spring_force.x, fake_spring_force.y);
//	NSLog(@"simple spring %f %f", simple_spring_force.x, simple_spring_force.y);
}

- (CGPoint)fake_spring:(CGPoint)position dt:(ccTime)dt {
	CGPoint c = cgp_add(
			cgp_times(position, damping / (2.0 * gamma)),
			cgp_times(egg.velocity, 1 / gamma)
	);

	CGPoint target = cgp_add(
			cgp_times(position, cosf(gamma * dt)),
			cgp_times(c, sinf(gamma * dt))
	);
	cgp_scale(&target, expf(-0.5 * dt * damping));

	CGPoint accel = cgp_subtract(
			cgp_times(cgp_subtract(target, position), (1 / dt * dt)),
			cgp_times(egg.velocity, dt)
	);
	cgp_scale(&accel, 1000);
	return accel;
}

- (CGPoint)simpleSpringForce:(float)penetration {
	float force_magnitude = spring_constant * penetration;
	CGPoint force = cgp_times(trampoline.normal, force_magnitude);
	return force;
}

- (void)dealloc {
	[trampoline release];
	[egg release];
	[super dealloc];
}

@end