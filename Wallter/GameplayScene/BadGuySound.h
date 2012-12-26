//
// by najati 
// copyright Cyrus Innovation
//

#import "AudioPlayer.h"
#import "BadGuyObserver.h"

@interface BadGuySound : NSObject<BadGuyObserver>
- (id)init:(AudioPlayer *)_audio;
@end