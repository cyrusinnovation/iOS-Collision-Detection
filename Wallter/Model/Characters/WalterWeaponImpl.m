//
// by najati 
// copyright Cyrus Innovation
//


#import "WalterWeaponImpl.h"
#import "MeleeAttack.h"
#import "ProxyCollection.h"


@implementation WalterWeaponImpl {
	id<WalterSimulationActor> walterActor;
	Simulation *simulation;
}

@synthesize observer;

- (id)initFor:(id<WalterSimulationActor>)_walter in:(Simulation *)_simulation {
	self = [super init];
	if (!self) return self;

	observer = (ProxyCollection <WalterObserver> *) [[ProxyCollection alloc] init];

	walterActor = _walter;
	simulation = _simulation;

	return self;
}

- (void)attack {
	MeleeAttack *attack = [[MeleeAttack alloc] init:walterActor];
	[simulation addAttack:attack];

	[observer attacking:attack];
}

@end