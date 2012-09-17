#import "TrampolineSpring.h"
#import "Trampoline.h"

#import "CGPoint_ops.h"
#import "TrampolineMath.h"

@implementation TrampolineSpring {
	Egg *egg;

	bool alive;
	float spring_constant;
	float damping;
	float gamma;

	CGPoint left;
	CGPoint right;
	CGPoint normal;
}

@synthesize egg;
@synthesize alive;

- (id)initFrom:(CGPoint) _left to:(CGPoint) _right for:(Egg *)_egg {
	if (self = [super init]) {
		left = _left;
		right = _right;

		normal = cgp_subtract(right, left);
		cgp_normalize(&normal);
		cgp_flop(&normal);

		egg = _egg;
		alive = true;

		spring_constant = 10000;
		damping = 2;

		gamma = 0.5 * sqrtf(4 * spring_constant - damping * damping);
		assert(gamma != 0);
	}
	return self;
}

- (float)eggPenetration:(Egg *)_egg {
	CGPoint egg_bottom = cgp_add(_egg.location, cgp_times(normal, -_egg.radius));

	float distance = pointToLineDistance(left, right, egg_bottom);
	if (isAbove(left, right, egg_bottom)) return -distance;
	return distance;
}

- (void)update:(ccTime)dt {
	if (!alive) {
		return;
	}

	float penetration = [self eggPenetration:egg];
	float t = cgp_t(left, right, egg.location);

	if (penetration < 0 || t < 0 || t > 1) {
		alive = false;
		return;
	}

	CGPoint position = cgp_add(egg.location, cgp_times(normal, -(egg.radius)));
	CGPoint anchor = cgp_add(left, cgp_times(cgp_subtract(right, left), t));
	position = cgp_subtract(position, anchor);

	CGPoint fake_spring_force = [self fake_spring:position dt:dt];

	[egg applyForce:fake_spring_force];
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

	CGPoint force = cgp_subtract(
			cgp_times(cgp_subtract(target, position), (1 / dt * dt)),
			cgp_times(egg.velocity, dt)
	);
	cgp_scale(&force, 1000); // I have no idea why I have to do this
	return force;
}

- (void)dealloc {
	[egg release];
	[super dealloc];
}

- (CGPoint)bend {
	if (alive) {
		return cgp_subtract(egg.location, cgp_times(normal, egg.radius));
	} else {
		return cgp_times(cgp_add(left, right), 0.5);
	}
}
@end