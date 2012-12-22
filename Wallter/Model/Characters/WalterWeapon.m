//
// by najati 
// copyright Cyrus Innovation
//


#import "WalterWeapon.h"
#import "Walter.h"
#import "Simulation.h"
#import "MeleeAttack.h"
#import "WalterWeaponObserver.h"


@implementation WalterWeapon {
	Walter *walter;
	Simulation *simulation;
	id<WalterWeaponObserver> observer;
}

@synthesize observer;

- (id)initFor:(Walter *)_walter in:(Simulation *)_simulation {
	self = [super init];
	if (!self) return self;

	walter = _walter;
	simulation = _simulation;
	
	return self;
}

- (void)attack {
	MeleeAttack *attack = [[MeleeAttack alloc] init:walter];
	[simulation addAttack:attack];

	if (observer) {
		[observer attacking:attack];
	}
}

@end