//
// Created by najati on 9/24/12.
//

#import "Simulation.h"
#import "SeparatingAxisTest.h"
#import "MeleeAttack.h"

@implementation Simulation {
	Guy *guy;
	Stage *stage;
	NSMutableArray *attacks;
	NSMutableArray *badguys;
}

@synthesize guy;
@synthesize stage;

- (id)initFor:(Guy *)_guy in:(Stage *)_stage {
	if (self = [super init]) {
		guy = _guy;
		stage = _stage;
		attacks = [[NSMutableArray alloc] init];
		badguys = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)update:(ccTime)dt {
	[guy update:dt];
	for (MeleeAttack *attack in attacks) {
		[attack update:dt];
	}
	for (NSValue *wallObject in stage.walls) {
		CGPolygon wall;
		[wallObject getValue:&wall];
		SATResult result = sat_test(guy.polygon, wall);
		if (result.penetrating) {
			[guy correct:result.penetration];
		}
	}
}

- (void)dealloc {
	[guy release];
	[stage release];
	[super dealloc];
}

- (void)addAttack:(MeleeAttack *)_attack {
	[attacks addObject:_attack];
}

- (void)addBadGuy:(BadGuy *)bg {
	[badguys addObject:bg];
}
@end