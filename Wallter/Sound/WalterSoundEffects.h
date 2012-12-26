//
// by najati 
// copyright Cyrus Innovation
//

#import "WalterObserver.h"
#import "AudioPlayer.h"

@interface WalterSoundEffects : NSObject <WalterObserver>
- (id)init:(AudioPlayer *)player;
@end