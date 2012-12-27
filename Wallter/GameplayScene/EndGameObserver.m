//
// by najati 
// copyright Cyrus Innovation
//


#import "WalterObserver.h"

#import "EndGameObserver.h"
#import "MeleeAttack.h"

@implementation EndGameObserver {
	void (^callback)();
}

- (void)dying {
	callback();
}

- (id)init:(void (^)())_callback {
	self = [super init];
	if (!self) return self;

	callback = _callback;

	return self;
}

- (void)runningLeft { }
- (void)runningRight { }
- (void)wallJumping { }
- (void)groundJumping { }
- (void)falling { }
- (void)running { }
- (void)attacking:(MeleeAttack *)attack { }

@end