//
// by najati 
// copyright Cyrus Innovation
//

#import "ProxyCollection.h"
#import "SimulationActor.h"

#import "Walter.h"
#import "WalterSimulationActorImpl.h"
#import "WalterWeaponImpl.h"

@implementation Walter {
	NSObject<WalterObservable> *actor;
	NSObject<WalterObservable> *weapon;
}

@synthesize observer;

+ (Walter *)from:(WalterSimulationActorImpl *)actor and:(WalterWeaponImpl *)weapon {
	return [[self alloc] init:actor weapon:weapon];
}

- (id)init:(WalterSimulationActorImpl *)_actor weapon:(WalterWeaponImpl *)_weapon {
	self = [super init];
	if (!self) return self;

	observer = (ProxyCollection <WalterObserver> *) [[ProxyCollection alloc] init];

	actor = _actor;
	weapon = _weapon;

	[weapon.observer add:observer];
	[actor.observer add:observer];

	return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	if ([actor respondsToSelector:anInvocation.selector]) {
		[anInvocation invokeWithTarget:actor];
	} else if ([weapon respondsToSelector:anInvocation.selector]) {
		[anInvocation invokeWithTarget:weapon];
	} else{
		[super forwardInvocation:anInvocation];
	}
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	NSMethodSignature *ret = [actor methodSignatureForSelector:aSelector];
	if (ret) return ret;

	ret = [weapon methodSignatureForSelector:aSelector];
	if (ret) return ret;

	return [super methodSignatureForSelector:aSelector];
}

@end