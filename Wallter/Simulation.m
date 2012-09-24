//
// Created by najati on 9/24/12.
//

#import "Simulation.h"
#import "ccTypes.h"
#import "SeparatingAxisTest.h"
#import "SATResult.h"

@implementation Simulation {

	Guy *guy;
	Stage *stage;
}

@synthesize guy;
@synthesize stage;

- (id)initFor:(Guy *)_guy in:(Stage *)_stage {
	if (self = [super init]) {
		guy = _guy;
		stage = _stage;
	} 
	return self;
}

- (void)update:(ccTime)dt {
	[guy update:dt];
	for (NSValue *wallObject in stage.walls) {
		CGPolygon wall;
		[wallObject getValue:&wall];
		SATResult result = sat_test(guy.polygon, wall);
		if (result.penetrating) {
			[guy correct:result.penetration];
		}
	}
}

- (void)dealloc {
	[guy release];
	[stage release];
	[super dealloc];
}

@end