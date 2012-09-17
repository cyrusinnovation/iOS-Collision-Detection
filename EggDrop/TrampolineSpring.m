#import "TrampolineSpring.h"
#import "Trampoline.h"
#import "Egg.h"

#import "TrampolineMath.h"
#import "CGPoint_ops.h"
#import "WorldConstants.h"

@implementation TrampolineSpring {
	Egg *egg;
	Trampoline *trampoline;

	bool alive;
}

@synthesize trampoline;
@synthesize egg;
@synthesize alive;

- (id)initFor:(Trampoline *)_trampoline and:(Egg *)_egg {
	if (self = [super init]) {
		trampoline = _trampoline;
		egg = _egg;
		alive = true;
	}
	return self;
}

- (void)update:(ccTime)dt {
	if (!alive) {
		return;
	}

	float penetration = [trampoline eggPenetration:egg];
	if (penetration < 0) {
		alive = false;
		return;
	}

	float k = 20;
	float d = 0;
	float gamma = 0.5 * sqrtf(4 * k - d * d);
	if (gamma == 0) return;

//	float t = cgp_t(trampoline.left, trampoline.right, egg.location);

	// TODO OPT maybe use t to compute the location of the spring
//	CGPoint position = cgp_add(egg.location, cgp_times(trampoline.normal, -(egg.radius + penetration)));
	CGPoint anchor = cgp_times(cgp_add(trampoline.left, trampoline.right), 0.5);
	CGPoint position = cgp_subtract(egg.location, anchor);
	CGPoint c = cgp_add(
			cgp_times(position, d / (2.0 * gamma)),
			cgp_times(egg.velocity, 1 / gamma)
	);

	CGPoint target = cgp_add(
			cgp_times(position, cosf(gamma * dt)),
			cgp_times(c, sinf(gamma * dt))
	);
	cgp_scale(&target, expf(-0.5 * dt * d));

	CGPoint accel = cgp_subtract(
			cgp_times(cgp_subtract(target, position), (1 / dt * dt)),
			cgp_times(egg.velocity, dt)
	);
//	[egg boost:accel during:dt];

	float force = k * penetration;
	CGPoint boost = cgp_times(trampoline.normal, force);
	[egg boost:boost during:dt];

	NSLog(@"would be accel %f %f", accel.x, accel.y);
	NSLog(@"actually boost %f %f", boost.x, boost.y);

}

- (void)dealloc {
	[trampoline release];
	[egg release];
	[super dealloc];
}

@end