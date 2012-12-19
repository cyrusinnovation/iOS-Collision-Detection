//
// Created by najati on 9/24/12.
//

#import "Simulation.h"
#import "SeparatingAxisTest.h"
#import "MeleeAttack.h"
#import "Platform.h"
#import "Stage.h"
#import "Walter.h"

@implementation Simulation {
	id<BoundedPolygon, SimulationActor> walter;
	Stage *stage;
	NSMutableArray *attacks;
	NSMutableArray *enemies;
}

@synthesize stage;

- (id)initFor:(id<BoundedPolygon, SimulationActor>)_guy in:(Stage *)_stage {
	if (self = [super init]) {
		walter = _guy;
		stage = _stage;
		attacks = [[NSMutableArray alloc] init];
		enemies = [[NSMutableArray alloc] init];
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
		id<BoundedPolygon, SimulationActor> attack = [attacks objectAtIndex:j];
		[attack update:dt];
		if (attack.isExpired) {
			[attacks removeObjectAtIndex:j];
		} else {
			[self killBadGuysIfTheyTouchThisAttack:attack];
		}
	}
}

- (void)killBadGuysIfTheyTouchThisAttack:(MeleeAttack *)attack {
	for (int i = enemies.count - 1; i >= 0; i--) {
		id<SimulationActor, BoundedPolygon> badGuy = [enemies objectAtIndex:i];
		SATResult result = [Simulation test:badGuy against:attack];
		// test(badGuy, attack)
		if (result.penetrating) {
			[badGuy collides:result with:attack];
		}
		if (badGuy.isExpired) {
			[enemies removeObjectAtIndex:i];
		}
	}
}

- (void)killWalterIfHesTouchingABadGuy {
	for (id<BoundedPolygon> badGuy in enemies) {
		SATResult result = [Simulation test:badGuy against:walter];
		if (result.penetrating) {
			[walter collides:result with:badGuy];
		}
	}
}

- (void)correctWalterPositionGivenCollisionsWithWalls {
	for (id<BoundedPolygon> wall in stage.elements) {
		SATResult result = [Simulation test:wall against:walter];
		if (result.penetrating) {
			[walter collides:result with:wall];
		}
	}
}

- (void)addAttack:(id<BoundedPolygon, SimulationActor>)_attack {
	[attacks addObject:_attack];
}

- (void)addEnemy:(id<BoundedPolygon, SimulationActor>)enemy {
	[enemies addObject:enemy];
}
@end