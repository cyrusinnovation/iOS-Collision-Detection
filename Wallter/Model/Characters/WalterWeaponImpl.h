//
// by najati 
// copyright Cyrus Innovation
//

#import "WalterSimulationActorImpl.h"
#import "Simulation.h"
#import "Walter.h"

@class ProxyCollection;

@interface WalterWeaponImpl : NSObject<WalterWeapon,WalterObservable>
- (id)initFor:(id<WalterSimulationActor>)_walter in:(Simulation *)_simulation;
@end