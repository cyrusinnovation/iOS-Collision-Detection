//
// Created by najati on 9/24/12.
//

#import "Simulation.h"

#import "SeparatingAxisTest.h"

@implementation Simulation {
	NSMutableArray *tickers;
}

@synthesize environment;
@synthesize characters;
@synthesize actors;

- (id)init {
	self = [super init];
	if (!self) return self;

	environment = [[NSMutableArray alloc] init];
	actors = [[NSMutableArray alloc] init];
	characters = [[NSMutableArray alloc] init];
	tickers = [[NSMutableArray alloc] init];

	return self;
}

- (void)update:(ccTime)dt {
	[self update:environment dt:dt];
	[self update:actors dt:dt];
	[self update:characters dt:dt];

	[self testMultiple:actors against:environment];
	[self testMultiple:actors against:characters];

	for (id<SimulationTicker> ticker in tickers) {
		[ticker update:dt];
	}
}

- (void)update:(NSMutableArray *)subjects dt:(ccTime)dt {
	for (int i = subjects.count - 1; i >= 0; i--) {
		id <BoundedPolygon, SimulationActor> actor = [subjects objectAtIndex:i];
		if (actor.expired) {
			[subjects removeObjectAtIndex:i];
		} else {
			[actor update:dt];
		}
	}
}

- (void)testMultiple:(NSMutableArray *)subjects against:(NSMutableArray *)polygons {
	for (id <BoundedPolygon, SimulationActor> actor in subjects) {
		[self test:actor against:polygons];
	}
}

- (void)test:(id <BoundedPolygon, SimulationActor>)this against:(NSMutableArray *)those {
	for (id <BoundedPolygon, SimulationActor> that in those) {
		[Simulation test:this against:that does:^(SATResult result) {
			[this collides:result with:that];
			[that collides:result with:this];
		}];
	}
}

- (void)addActor:(id <BoundedPolygon, SimulationActor>)actor {
	[actors addObject:actor];
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