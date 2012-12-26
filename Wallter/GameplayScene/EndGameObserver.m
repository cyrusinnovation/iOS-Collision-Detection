//
// by najati 
// copyright Cyrus Innovation
//


#import "WalterObserver.h"

#import "EndGameObserver.h"

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


@end