//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "CCDirector.h"

#import "Simulation.h"
#import "SimulationObserver.h"
#import "NullSimulationObserver.h"
#import "Trampoline.h"

@implementation Simulation {
	NSMutableArray *stars;
	NSObject <SimulationObserver> *observer;
	Egg *egg;

	NSMutableArray *trampolines;
	CGPoint initial_egg_location;
}

@synthesize observer;
@synthesize egg;

- (id)initWithInitialEggLocation:(CGPoint)location {
	if (self == [super init]) {
		initial_egg_location = location;
		egg = [[Egg alloc] initAt:initial_egg_location withRadius:15];;

		stars = [[NSMutableArray alloc] init];
		trampolines = [[NSMutableArray alloc] init];

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

- (void)addTrampolineFrom:(CGPoint)start to:(CGPoint)end {
	Trampoline *trampoline = [[Trampoline alloc] initFrom:start to:end];
	[trampolines addObject:trampoline];
	[observer newTrampoline:trampoline];
}

- (void)update:(ccTime)dt {
	[egg resetForce];
	[self collectForces];
	[self runForces:dt];
	[egg update:dt];
	// TODO it feels weird for this to bed in here - this is more the sprite's responsibility
	[self updateTrampolineGeometry];
	[self checkForStarCollisions];
}

- (void)updateTrampolineGeometry {
	for (Trampoline *trampoline in trampolines) {
		[trampoline updateGeometry];
	}
}

- (void)runForces:(ccTime)dt {
// TODO eventually this should just be running force generators
	for (Trampoline *trampoline in trampolines) {
		[trampoline update:dt];
	}
}

- (void)collectForces {
// TODO eventually this should return force generators and the simulation should hold on to and run them
	for (Trampoline *trampoline in trampolines) {
		[trampoline consider:egg];
	}
}

- (void)checkForStarCollisions {
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
	[egg release];
	[super dealloc];
}

- (void)resetCurrentArrangement {
	[self removeAllStars];
	[self moveEggTo:initial_egg_location];

	for (Trampoline *trampoline in trampolines) {
		[trampoline reset];
	}
}

- (void)removeAllStars {
	for (int i = stars.count - 1; i >= 0; i--) {
		Star *star = [stars objectAtIndex:i];
		[observer starCaught:star];
		[stars removeObject:star];
	}
}

- (void)moveEggTo:(CGPoint)location {
	[egg resetTo:location];
}

- (BOOL)isEggDead {
	return egg.location.y < -20 ||
			egg.location.x < -20 ||
			egg.location.x > ([[CCDirector sharedDirector] winSize]).width + 30;
}

- (void)resetCurrentStage {
	[self moveEggTo:initial_egg_location];
	[trampolines removeAllObjects];
}
@end
