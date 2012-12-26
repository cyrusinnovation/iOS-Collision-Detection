//
// by najati 
// copyright Cyrus Innovation
//

#import "Simulation.h"
#import "WalterWeaponObserver.h"

@interface WalterWeapon : NSObject

@property(nonatomic, retain) id<WalterWeaponObserver> observer;

- (id)initFor:(WalterSimulationActor *)_walter in:(Simulation *)_simulation;

- (void)attack;

@end