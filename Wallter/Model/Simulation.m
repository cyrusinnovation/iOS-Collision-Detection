//
// Created by najati on 9/24/12.
//

#import "Simulation.h"

#import "SeparatingAxisTest.h"

@implementation Simulation {
	id <BoundedPolygon, SimulationActor> mainActor;
	NSMutableArray *tickers;
}

@synthesize environment;
@synthesize characters;
@synthesize attacks;

- (id)initFor:(id <BoundedPolygon, SimulationActor>)_mainActor {
	if (self = [super init]) {
		mainActor = _mainActor;
		environment = [[NSMutableArray alloc] init];
		attacks = [[NSMutableArray alloc] init];
		characters = [[NSMutableArray alloc] init];
		tickers = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)update:(ccTime)dt {
	[mainActor update:dt];

	[self update:environment dt:dt];
	[self test:mainActor against:environment];

	[self update:attacks dt:dt];
	[self testMultiple:characters against:attacks];

	[self update:characters dt:dt];
	[self test:mainActor against:characters];

	for (id<SimulationTicker> ticker in tickers) {
		[ticker update:dt];
	}
}

- (void)update:(NSMutableArray *)actors dt:(ccTime)dt {
	for (int i = actors.count - 1; i >= 0; i--) {
		id <BoundedPolygon, SimulationActor> actor = [actors objectAtIndex:i];
		if (actor.expired) {
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
	[characters addObject:enemy];
}

- (void)addEnvironmentElement:(id <BoundedPolygon, SimulationActor>)element {
	[environment addObject:element];
}

- (void)addTicker:(id <SimulationTicker>)ticker {
	[tickers addObject:ticker];
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