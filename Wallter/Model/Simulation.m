//
// Created by najati on 9/24/12.
//

#import "Simulation.h"

#import "SeparatingAxisTest.h"
#import "SATResult.h"

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
	[mainActor update:dt];
	[self test:mainActor against:environment.elements];

	[self update:attacks dt:dt];
	[self testMultiple:enemies against:attacks];

	[self update:enemies dt:dt];
	[self test:mainActor against:enemies];
}

- (void)update:(NSMutableArray *)actors dt:(ccTime)dt {
	for (int i = actors.count - 1; i >= 0; i--) {
		id <BoundedPolygon, SimulationActor> actor = [actors objectAtIndex:i];
		if (actor.isExpired) {
			[actors removeObjectAtIndex:i];
		} else {
			[actor update:dt];
		}
	}
}

- (void)testMultiple:(NSMutableArray *)actors against:(NSMutableArray *)polygons {
	for (id <BoundedPolygon, SimulationActor> actor in actors) {
		[self test:actor against:polygons];
	}
}

- (void)test:(id <BoundedPolygon, SimulationActor>)actor against:(NSMutableArray *)polygons {
	for (id <BoundedPolygon> polygon in polygons) {
		[Simulation test:actor against:polygon does:^(SATResult result) {
			[actor collides:result with:polygon];
		}];
	}
}

- (void)addAttack:(id <BoundedPolygon, SimulationActor>)attack {
	[attacks addObject:attack];
}

- (void)addEnemy:(id <BoundedPolygon, SimulationActor>)enemy {
	[enemies addObject:enemy];
}

#pragma mark Static methods

+ (void)test:(id <BoundedPolygon>)this against:(id <BoundedPolygon>)that does:(void (^) (SATResult))block {
	if (that.bottom > this.top) return;
	if (that.top < this.bottom) return;
	if (that.right < this.left) return;
	if (that.left > this.right) return;

	SATResult result = sat_test(this.polygon, that.polygon);
	if (result.penetrating) {
		block(result);
	}
}

@end