//
// by najati 
// copyright Cyrus Innovation
//


#import "ccTypes.h"

#import "SimulationTiming.h"
#import "Simulation.h"

@implementation SimulationTiming {
	Simulation *simulation;

	ccTime timeBuffer;
	ccTime simulationTimeStep;
	float scale;

	BOOL paused;
}

- (id)init:(float)_simulationTimeStep scale:(float)_scale simulation:(Simulation *)_simulation {
	self = [super init];
	if (!self) return self;

	simulation = _simulation;

	timeBuffer = 0;
	simulationTimeStep = _simulationTimeStep;
	scale = _scale;

	paused = false;

	return self;
}

- (void)update:(ccTime)dt {
	if (paused) return;

	timeBuffer += dt * scale;
	while (timeBuffer >= simulationTimeStep) {
		timeBuffer -= simulationTimeStep;
		[simulation update:simulationTimeStep];
	}
}

- (void)pause {
	paused = true;
}

@end