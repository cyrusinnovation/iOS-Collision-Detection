//
// by najati 
// copyright Cyrus Innovation
//

#import "WalterObserver.h"
#import "AudioPlayer.h"
#import "WalterWeaponObserver.h"

@interface WalterSoundEffects : NSObject <WalterObserver,WalterWeaponObserver>
- (id)init:(AudioPlayer *)player;
@end