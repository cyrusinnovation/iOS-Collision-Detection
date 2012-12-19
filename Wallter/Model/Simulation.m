//
// Created by najati on 9/24/12.
//

#import "Simulation.h"
#import "SeparatingAxisTest.h"
#import "MeleeAttack.h"
#import "SATResult.h"
#import "Platform.h"

@implementation Simulation {
	Walter *guy;
	Stage *stage;
	NSMutableArray *attacks;
	NSMutableArray *badguys;
}

@synthesize guy;
@synthesize stage;

- (id)initFor:(Walter *)_guy in:(Stage *)_stage {
	if (self = [super init]) {
		guy = _guy;
		stage = _stage;
		attacks = [[NSMutableArray alloc] init];
		badguys = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)update:(ccTime)dt {
//	for (int i = actors.count - 1; i >= 0; i--) {
//		SimulationActor *actor = [actors objectAtIndex:i];
//		if (actor.isDead) {
//			[actors removeObjectAtIndex:i];
//		} else {
//			[actors update:dt];
//		}
//	}
//
//	for (int i = actors.count - 1; i >= 0; i--) {
//		[actors update:dt];
//	}

	[guy update:dt];
	[self updateAttacks:dt];
	[self killWalterIfHesTouchingABadGuy];
	[self correctWalterPositionGivenCollisionsWithWalls];
}

- (void)updateAttacks:(ccTime)dt {
	for (int j = attacks.count - 1; j >= 0; j--) {
		MeleeAttack *attack = [attacks objectAtIndex:j];
		[attack update:dt];
		if (attack.isDead) {
			[attacks removeObjectAtIndex:j];
		} else {
			[self killBadGuysIfTheyTouchThisAttack:attack];
		}
	}
}

- (void)killBadGuysIfTheyTouchThisAttack:(MeleeAttack *)attack {
	for (int i = badguys.count - 1; i >= 0; i--) {
		BadGuy *badGuy = [badguys objectAtIndex:i];
		SATResult result = sat_test(badGuy.polygon, attack.polygon);
		// test(badGuy, attack)
		if (result.penetrating) {
			[badGuy kill];
		}
		if (badGuy.dead) {
			[badguys removeObjectAtIndex:i];
		}
	}
}

- (void)killWalterIfHesTouchingABadGuy {
	for (BadGuy *badGuy in badguys) {
		SATResult result = sat_test(badGuy.polygon, guy.polygon);
		if (result.penetrating) {
			[guy kill];
		}
	}
}

+ (SATResult)test:(id<BoundedPolygon>) this against:(id<BoundedPolygon>)that {
	if (that.bottom > this.top ||
			that.top < this.bottom ||
			that.right < this.left ||
			that.left > this.right) {
		return (SATResult) {cgp(0, 0), false};
	}
	return sat_test(that.polygon, this.polygon);
}

- (void)correctWalterPositionGivenCollisionsWithWalls {
	for (Platform *wall in stage.walls) {
		SATResult result = [Simulation test:wall against:guy];
		if (result.penetrating) {
			[guy correct:result.penetration];
		}
	}
}

- (void)addAttack:(MeleeAttack *)_attack {
	[attacks addObject:_attack];
}

- (void)addBadGuy:(BadGuy *)bg {
	[badguys addObject:bg];
}
@end