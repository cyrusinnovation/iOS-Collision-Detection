//
// by najati 
// copyright Cyrus Innovation
//

#import "WalterObserver.h"

@interface AggregateWalterObserver : NSObject <WalterObserver>
- (id)initWithObservers:(NSArray *) observers;
@end