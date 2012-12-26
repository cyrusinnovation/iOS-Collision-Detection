//
// by najati 
// copyright Cyrus Innovation
//

#import "ElementOnScreenObserver.h"
#import "SimulationTicker.h"
#import "Simulation.h"
#import "Camera.h"

@interface EnterAndExitTicker : NSObject<SimulationTicker>
- (id)init:(Simulation *)_simulation camera:(Camera *)_camera listener:(id <ElementOnScreenObserver>)_listener;
@end