//
// by najati 
// copyright Cyrus Innovation
//


@interface EndGameObserver : NSObject<WalterObserver>
- (id)init:(void (^)())callback;
@end