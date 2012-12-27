//
// by najati 
// copyright Cyrus Innovation
//

@class MeleeAttack;

@protocol WalterObserver <NSObject>
- (void)runningLeft;
- (void)runningRight;
- (void)wallJumping;
- (void)groundJumping;
- (void)falling;
- (void)running;
- (void)dying;
- (void)attacking;
@end