//
// by najati 
// copyright Cyrus Innovation
//

#import "BadGuySound.h"
#import "AudioPlayer.h"

@implementation BadGuySound {
	AudioPlayer *audio;
}

- (id)init:(AudioPlayer *)_audio {
	self = [super init];
	if (!self) return self;
	
	audio = _audio;

	return self;
}

- (void)badGuyDied {
	[audio playEffect:@"DSPODTH3.WAV"];
}

@end