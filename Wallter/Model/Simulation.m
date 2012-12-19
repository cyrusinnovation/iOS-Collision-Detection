//
// Created by najati on 9/24/12.
//

#import "Simulation.h"
#import "SeparatingAxisTest.h"
#import "MeleeAttack.h"
#import "Platform.h"

@implementation Simulation {
	id<BoundedPolygon, SimulationActor> walter;
	Stage *stage;
	NSMutableArray *attacks;
	NSMutableArray *badguys;
}

@synthesize stage;

- (id)initFor:(id<BoundedPolygon, SimulationActor>)_guy in:(Stage *)_stage {
	if (self = [super init]) {
		walter = _guy;
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

	[walter update:dt];
	[self updateAttacks:dt];
	[self killWalterIfHesTouchingABadGuy];
	[self correctWalterPositionGivenCollisionsWithWalls];
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
		id<SimulationActor, BoundedPolygon> badGuy = [badguys objectAtIndex:i];
		SATResult result = [Simulation test:badGuy against:attack];
		// test(badGuy, attack)
		if (result.penetrating) {
			[badGuy collides:result with:attack];
		}
		if (badGuy.isExpired) {
			[badguys removeObjectAtIndex:i];
		}
	}
}

- (void)killWalterIfHesTouchingABadGuy {
	for (id<BoundedPolygon> badGuy in badguys) {
		SATResult result = [Simulation test:badGuy against:walter];
		if (result.penetrating) {
			[walter collides:result with:badGuy];
		}
	}
}

- (void)correctWalterPositionGivenCollisionsWithWalls {
	for (Platform *wall in stage.walls) {
		SATResult result = [Simulation test:wall against:walter];
		if (result.penetrating) {
			[walter collides:result with:wall];
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