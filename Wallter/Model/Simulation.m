//
// Created by najati on 9/24/12.
//

#import "Simulation.h"

#import "SeparatingAxisTest.h"

@implementation Simulation {
	id <BoundedPolygon, SimulationActor> mainActor;
	id <Environment> environment;
	NSMutableArray *attacks;
	NSMutableArray *enemies;
}

- (id)initFor:(id <BoundedPolygon, SimulationActor>)_mainActor in:(id <Environment>)_environment {
	if (self = [super init]) {
		mainActor = _mainActor;
		environment = _environment;
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

	[mainActor update:dt];
	[self testMainActorAgainstPolys:environment.elements];

	[self updateActors:dt actors:attacks];
	[self testEnemiesAgainstAttacks];

	[self updateActors:dt actors:enemies];
	[self testMainActorAgainstPolys:enemies];
}

+ (SATResult)test:(id <BoundedPolygon>)this against:(id <BoundedPolygon>)that {
	if (that.bottom > this.top ||
			that.top < this.bottom ||
			that.right < this.left ||
			that.left > this.right) {
		return (SATResult) {cgp(0, 0), false};
	}
	return sat_test(that.polygon, this.polygon);
}

- (void)updateActors:(ccTime)dt actors:(NSMutableArray *)actors {
	for (int i = actors.count - 1; i >= 0; i--) {
		id <BoundedPolygon, SimulationActor> actor = [actors objectAtIndex:i];
		if (actor.isExpired) {
			[actors removeObjectAtIndex:i];
		} else {
			[actor update:dt];
		}
	}
}

- (void)testEnemiesAgainstAttacks {
	for (int j = attacks.count - 1; j >= 0; j--) {
		id <BoundedPolygon, SimulationActor> attack = [attacks objectAtIndex:j];
		for (int i = enemies.count - 1; i >= 0; i--) {
			id <SimulationActor, BoundedPolygon> enemy = [enemies objectAtIndex:i];

			SATResult result = [Simulation test:enemy against:attack];
			if (result.penetrating) {
				[enemy collides:result with:attack];
			}
		}
	}
}

- (void)testMainActorAgainstPolys:(NSMutableArray *)array {
	for (id <BoundedPolygon> badGuy in array) {
		SATResult result = [Simulation test:badGuy against:mainActor];
		if (result.penetrating) {
			[mainActor collides:result with:badGuy];
		}
	}
}

- (void)addAttack:(id <BoundedPolygon, SimulationActor>)attack {
	[attacks addObject:attack];
}

- (void)addEnemy:(id <BoundedPolygon, SimulationActor>)enemy {
	[enemies addObject:enemy];
}
@end