//
// by najati 
// copyright Cyrus Innovation
//


@protocol WalterObserver <NSObject>
- (void)runningLeft;
- (void)runningRight;
- (void)wallJumping;
- (void)groundJumping;
- (void)falling;
- (void)running;
@end