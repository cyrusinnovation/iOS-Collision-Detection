//
// by najati 
// copyright Cyrus Innovation
//


#import "WalterWeapon.h"
#import "MeleeAttack.h"


@implementation WalterWeapon {
	WalterSimulationActor *walterActor;
	Simulation *simulation;
	id<WalterObserver> observer;
}

@synthesize observer;

- (id)initFor:(WalterSimulationActor *)_walter in:(Simulation *)_simulation {
	self = [super init];
	if (!self) return self;

	walterActor = _walter;
	simulation = _simulation;
	
	return self;
}

- (void)attack {
	MeleeAttack *attack = [[MeleeAttack alloc] init:walterActor];
	[simulation addAttack:attack];

	if (observer) {
		[observer attacking:attack];
	}
}

@end