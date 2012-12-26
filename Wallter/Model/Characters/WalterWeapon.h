//
// by najati 
// copyright Cyrus Innovation
//

#import "WalterSimulationActor.h"
#import "Simulation.h"

@interface WalterWeapon : NSObject

@property(nonatomic, retain) id<WalterObserver> observer;

- (id)initFor:(WalterSimulationActor *)_walter in:(Simulation *)_simulation;

- (void)attack;

@end