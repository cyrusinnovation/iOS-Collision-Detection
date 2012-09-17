//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "CCDirector.h"

#import "Simulation.h"
#import "NullSimulationObserver.h"
#import "Trampoline.h"
#import "Level.h"

@implementation Simulation {
	NSMutableArray *stars;
	NSMutableArray *trampolines;
	NSObject <SimulationObserver> *observer;

	Level *level;
}

@synthesize observer;
@synthesize egg;
@synthesize nest;
@synthesize paused;

- (id)init:(Level *)_level {
	if (self == [super init]) {
		level = _level;
		egg = [[Egg alloc] initAt:level.initialEggLocation withRadius:15];;
		nest = [[Nest alloc] initAt:level.nestLocation];

		stars = [[NSMutableArray alloc] init];
		trampolines = [[NSMutableArray alloc] init];

		observer = [[NullSimulationObserver alloc] init];
	}
	return self;
}

- (Star *)addStar:(CGPoint)location {
	CGSize s = [[CCDirector sharedDirector] winSize];
	Star *star = [[Star alloc] initAt:s.width * location.x and:s.height * location.y];
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
	if (self.paused)
	    return;
	[egg resetForce];
	[self collectForces];
	[self runForces:dt];
	[egg update:dt];
	// TODO it feels weird for this to bed in here - this is more the sprite's responsibility
	[self updateTrampolineGeometry];
	[self checkForStarCollisions];
	[nest handle:egg];
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
		}
	}
}

- (void)dealloc {
	[observer release];
	[egg release];
	[nest release];
	[super dealloc];
}

- (void) redropEgg {
	[self resetStars];
	[egg resetTo:level.initialEggLocation];
}

- (void) startLevelOver {
	[self removeAllTrampolines];
	[self redropEgg];
}

- (void)removeAllTrampolines {
	[trampolines removeAllObjects];
	[observer trampolinesRemoved];
}

- (void)resetStars {
	for (int i = stars.count - 1; i >= 0; i--) {
		Star *star = [stars objectAtIndex:i];
		[observer starCaught:star];
		[stars removeObject:star];
	}

	for (NSValue *value in level.starLocations) {
		CGPoint location;
		[value getValue:&location];
		[self addStar:location];
	}
}

- (BOOL)isEggDead {
	return egg.location.y < -20 ||
			egg.location.x < -20 ||
			egg.location.x > ([[CCDirector sharedDirector] winSize]).width + 30;
}

-(void)pause {
    self.paused = YES;
}

-(void)unpause {
    self.paused = NO;
}

@end
