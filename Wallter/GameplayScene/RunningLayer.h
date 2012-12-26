//
// najati
// copyright cyrus innovation
//

#import "ElementOnScreenObserver.h"

#import "WalterSimulationActor.h"
#import "Simulation.h"
#import "WalterWeapon.h"

#define INTERFACE_LAYER 100

@interface RunningLayer : CCLayerColor
+ (CCScene *)scene;
- (id)init:(WalterSimulationActor *)_actor and:(WalterWeapon *)_weapon and:(Simulation *)_simulation;
@end
