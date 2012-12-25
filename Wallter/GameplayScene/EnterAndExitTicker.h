//
// by najati 
// copyright Cyrus Innovation
//

#import "SimulationTicker.h"
#import "Simulation.h"
#import "Camera.h"

@interface EnterAndExitTicker : NSObject<SimulationTicker>
- (id)init:(Simulation *)_simulation camera:(Camera *)_camera;
@end