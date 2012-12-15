//
// by najati 
// copyright Cyrus Innovation
//

#import "NullWalterObserver.h"

@implementation NullWalterObserver

+ (NSObject <WalterObserver> *)instance {
	return [[NullWalterObserver alloc] init];
}

- (void)runningLeft { }
- (void)runningRight { }
- (void)wallJumping { }
- (void)groundJumping { }
- (void)falling { }
- (void)running { }

@end