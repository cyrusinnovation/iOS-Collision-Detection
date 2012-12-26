//
// by najati 
// copyright Cyrus Innovation
//


#import <Foundation/Foundation.h>

@class Simulation;


@interface SimulationTiming : NSObject
- (id)init:(float)_simulationTimeStep scale:(float)_scale simulation:(Simulation *)simulation;

- (void)update:(ccTime)dt;

- (void)pause;
@end