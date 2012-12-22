//
// Created by najati on 12/14/12.
//

#import "PlatformAddedObserver.h"
#import "Simulation.h"

@protocol SimulationObserver;

@interface AddBadGuyToStageObserver : NSObject<PlatformAddedObserver>
- (id)init:(Simulation *)simulation;
@end