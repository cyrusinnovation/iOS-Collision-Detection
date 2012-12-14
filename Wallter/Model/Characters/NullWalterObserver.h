//
// by najati 
// copyright Cyrus Innovation
//

#import "WalterObserver.h"

@interface NullWalterObserver : NSObject <WalterObserver>
+ (NSObject <WalterObserver> *)instance;
@end