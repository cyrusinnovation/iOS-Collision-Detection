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
#import "Wall.h"
#import "TrampolineSpring.h"

@implementation Simulation {
	NSMutableArray *stars;
	NSMutableArray *trampolines;
	NSMutableArray *walls;
	NSObject <SimulationObserver> *observer;

	Level *level;
	BOOL paused;
	NSMutableArray *forces;
}

@synthesize observer;
@synthesize egg;
@synthesize nest;
@synthesize walls;


- (id)init:(Level *)_level {
	if (self == [super init]) {
		paused = NO;
		forces = [[NSMutableArray alloc] init];

		level = _level;
		egg = [[Egg alloc] initAt:level.initialEggLocation withRadius:15];;
		nest = [[Nest alloc] initAt:level.nestLocation];
		walls = [Wall wallsFrom:level.wallLocations];

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
	if (paused)
		return;

	[egg resetForce];
	[self runForces:dt];

	[egg update:dt];
	// TODO it feels weird for this to bed in here - this is more the sprite's responsibility
	[self updateTrampolineGeometry];

	if ([self isEggDead]) {
		[observer eggDied];
	} else {
		[self checkForStarCollisions];
		[self checkForNestCollisions];
	}
}

- (void)runForces:(ccTime)dt {
	// TODO this being so tied to trampolines is going to bite us soon
	for (Trampoline *trampoline in trampolines) {
		[trampoline update:dt egg:egg];
	}
	for (Wall *wall in walls) {
		[wall update:dt egg:egg];
	}
}

- (void)updateTrampolineGeometry {
	for (Trampoline *trampoline in trampolines) {
		[trampoline updateGeometry];
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

- (void)checkForNestCollisions {
	if ([nest doesCollide:egg]) {
		[egg resetTo:egg.location];
		[observer eggHitNest];
	}
}

- (void)redropEgg {
	[self resetStars];
	[egg resetTo:level.initialEggLocation];
}

- (void) resetTrampolines {
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

- (void)dealloc {
	[observer release];
	[egg release];
	[nest release];
	[walls release];
	[super dealloc];
}

- (void)pause {
	paused = YES;
}

- (void)unpause {
	paused = NO;
}

- (void)cuttingTrampolineAtPoint:(CGPoint) cutPoint {
	Trampoline *cutTrampoline = nil;
	for (Trampoline *trampoline in trampolines) {
		if ([trampoline isPointOnTrampoline:cutPoint]) {
			cutTrampoline = trampoline;
			break;
		}
	}

	if (cutTrampoline) {
		[trampolines removeObject:cutTrampoline];
		[observer removeTrampoline:cutTrampoline];
	}
}

@end
