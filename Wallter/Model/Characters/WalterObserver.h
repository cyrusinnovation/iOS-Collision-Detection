//
// by najati 
// copyright Cyrus Innovation
//


@protocol WalterObserver <NSObject>
- (void)runningLeft;
- (void)runningRight;
- (void)wallJump;
- (void)groundJump;
@end