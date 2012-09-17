//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "CCDirector.h"

#import "Simulation.h"
#import "SimulationObserver.h"
#import "NullSimulationObserver.h"

@implementation Simulation {
	NSMutableArray *stars;
	NSObject <SimulationObserver> *observer;
	Egg *egg;
}

@synthesize observer;

- (id)initWith:(Egg *)_egg {
	if (self == [super init]) {
		egg = _egg;
		stars = [[NSMutableArray alloc] init];
		observer = [[NullSimulationObserver alloc] init];
	}
	return self;
}

- (Star *)addStarAt:(float)x and:(float)y {
	CGSize s = [[CCDirector sharedDirector] winSize];
	Star *star = [[Star alloc] initAt:s.width * x and:s.height * y];
	[stars addObject:star];
	[observer newStar:star];
	return star;
}

- (void)update:(ccTime)dt {
	[self processStars];
}

- (void)processStars {
	for (int i = stars.count - 1; i >= 0; i--) {
		Star *star = [stars objectAtIndex:i];
		if ([star doesCollide:egg]) {
			[observer starCaught:star];
			[stars removeObject:star];
			// TODO ? [release star];
		}
	}
}

- (void)dealloc {
	[observer release];
	[super dealloc];
}

- (void)reset {
	[self removeAllStars];
}

- (void)removeAllStars {
	for (int i = stars.count - 1; i >= 0; i--) {
		Star *star = [stars objectAtIndex:i];
		[observer starCaught:star];
		[stars removeObject:star];
	}
}

@end