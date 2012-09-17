//
//  Trampoline.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Trampoline.h"

#include "math.h"
#include "CGPoint_ops.h"

#import "WorldConstants.h"
#import "TrampolineMath.h"
#import "TrampolineSpring.h"

@implementation Trampoline

@synthesize left;
@synthesize right;

@synthesize bend;
@synthesize normal;

- (id)initFrom:(CGPoint)from to:(CGPoint)to {
	if (self = [super init]) {
		maxDepth = 10;
		active = false;

		[self setFrom:from to:to];

		springs = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)setFrom:(CGPoint)from to:(CGPoint)to {
	if (from.x < to.x) {
		self.left = from;
		self.right = to;
	} else {
		self.left = to;
		self.right = from;
	}

	self.bend = cgp_add(left, right);
	cgp_scale(&bend, 0.5f);

	normal = cgp_subtract(right, left);
	cgp_normalize(&normal);
	cgp_flop(&normal);

	stored = cgp(0, 0);
}

- (CGPoint)center {
	CGPoint center = cgp_add(left, right);
	cgp_scale(&center, 0.5f);
	return center;
}

- (float)angle {
	CGPoint blart = cgp_subtract(right, left);
	cgp_normalize(&blart);
	return 180 * acosf(cgp_dot(blart, cgp(0, 1))) / (float) M_PI;
}

- (float)width {
	return cgp_length(cgp_subtract(right, left));
}

// TODO I think since we're computing cgp_t below we might be able to tighten up the math in here
- (float)eggPenetration:(Egg *)_egg {
	CGPoint egg_bottom = cgp_add(_egg.location, cgp_times(normal, -_egg.radius));

	float distance = pointToLineDistance(self.left, self.right, egg_bottom);
	if (isAbove(left, right, egg_bottom)) return -distance;
	return distance;
}

- (void)resetBend {
	self.bend = cgp_add(left, right);
	cgp_scale(&bend, 0.5f);
}

- (void)setBendFor:(Egg *)_egg {
	bend = cgp_subtract(_egg.location, cgp_times(normal, _egg.radius));
}

- (void)consider:(Egg *)egg {
	for (TrampolineSpring *spring in springs) {
		if (spring.egg == egg) return;
	}

	float t = cgp_t(self.left, self.right, egg.location);
	if (t < 0 || t > 1) {
		return;
	}

	float distance = pointToLineDistance(self.left, self.right, egg.location);
	if (distance > egg.radius) {
		return;
	}

	[springs addObject:[[TrampolineSpring alloc] initFor:self and:egg]];
}

- (void)update:(ccTime)dt {
	for (TrampolineSpring *spring in springs) {
		[spring update:dt];
	}
	for (int i = springs.count - 1; i >= 0; i--) {
		TrampolineSpring *elem = [springs objectAtIndex:i];
		if (!elem.alive) {
			[springs removeObjectAtIndex:i];
		} else{
			[self setBendFor:elem.egg];
		}
	}
}

- (void)reset {
	stored = cgp(0, 0);
	[self resetBend];
}

- (CGPoint)left_center {
	CGPoint center = cgp_add(left, bend);
	cgp_scale(&center, 0.5f);
	return center;
}

- (float)left_angle {
	CGPoint blart = cgp_subtract(bend, left);
	cgp_normalize(&blart);
	return 180 * acosf(cgp_dot(blart, cgp(0, 1))) / M_PI;
}

- (float)left_width {
	return cgp_length(cgp_subtract(bend, left));
}


- (CGPoint)right_center {
	CGPoint center = cgp_add(bend, right);
	cgp_scale(&center, 0.5f);
	return center;
}

- (float)right_angle {
	CGPoint blart = cgp_subtract(right, bend);
	cgp_normalize(&blart);
	return 180 * acosf(cgp_dot(blart, cgp(0, 1))) / M_PI;
}

- (float)right_width {
	return cgp_length(cgp_subtract(right, bend));
}

@end