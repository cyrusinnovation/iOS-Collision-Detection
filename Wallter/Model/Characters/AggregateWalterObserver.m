//
// by najati 
// copyright Cyrus Innovation
//

#import "AggregateWalterObserver.h"
#import "MeleeAttack.h"

@implementation AggregateWalterObserver {
	NSArray *observers;
}

-(id)init {
	return [self initWithObservers:[[NSArray alloc] init]];
}

- (id)initWithObservers:(NSArray *) _observers {
	self = [super init];
	if (!self) return self;

	observers = _observers;

	return self;
}

- (void)runningLeft {
	for (id <WalterObserver> observer in observers) {[observer runningLeft];}
}

- (void)runningRight {
	for (id <WalterObserver> observer in observers) {[observer runningRight];}
}

- (void)wallJumping {
	for (id <WalterObserver> observer in observers) {[observer wallJumping];}
}

- (void)groundJumping {
	for (id <WalterObserver> observer in observers) {[observer groundJumping];}
}

- (void)falling {
	for (id <WalterObserver> observer in observers) {[observer falling];}
}

- (void)running {
	for (id <WalterObserver> observer in observers) {[observer running];}
}

- (void)dying {
	for (id <WalterObserver> observer in observers) {[observer dying];}
}

- (void)attacking:(MeleeAttack *)attack {
	for (id <WalterObserver> observer in observers) {[observer attacking:attack];}
}


@end