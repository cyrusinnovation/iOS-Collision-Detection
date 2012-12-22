//
// by najati 
// copyright Cyrus Innovation
//

#import "MeleeAttack.h"

@protocol WalterWeaponObserver <NSObject>
- (void)attacking:(MeleeAttack *)attack;
@end