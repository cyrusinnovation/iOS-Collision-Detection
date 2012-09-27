//
// Created by najati on 9/24/12.
//

#import "Simulation.h"
#import "SeparatingAxisTest.h"
#import "MeleeAttack.h"
#import "SATResult.h"
#import "Platform.h"

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
	for (int j = attacks.count - 1; j >= 0; j--) {
		MeleeAttack *attack = [attacks objectAtIndex:j];

		[attack update:dt];

		if (attack.isDead) {
			[attacks removeObjectAtIndex:j];
		} else {
			for (int i = badguys.count -1; i >= 0; i--) {
				BadGuy *badGuy = [badguys objectAtIndex:i];
				SATResult result = sat_test(badGuy.polygon, attack.polygon);
				if (result.penetrating) {
					[badGuy kill];
				}
				if (badGuy.dead) {
					[badguys removeObjectAtIndex:i];
				}
			}
		}
	}

	for (BadGuy *badGuy in badguys) {
		SATResult result = sat_test(badGuy.polygon, guy.polygon);
		if (result.penetrating) {
			[guy kill];
		}
	}

	for (Platform *wall in stage.walls) {
		SATResult result = sat_test(guy.polygon, wall.polygon);
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