//
// by najati 
// copyright Cyrus Innovation
//

#import "ProxyCollection.h"
#import "SimulationActor.h"

#import "Walter.h"
#import "WalterSimulationActorImpl.h"

@implementation Walter {
	NSObject<WalterSimulationActor,WalterObservable> *actor;
	NSObject<WalterWeapon,WalterObservable> *weapon;
}

@synthesize observer;

+ (Walter *)from:(NSObject<WalterSimulationActor,WalterObservable> *)actor and:(NSObject<WalterWeapon,WalterObservable> *)weapon {
	return [[self alloc] init:actor weapon:weapon];
}

- (id)init:(NSObject<WalterSimulationActor,WalterObservable> *)_actor weapon:(NSObject<WalterWeapon,WalterObservable> *)_weapon {
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