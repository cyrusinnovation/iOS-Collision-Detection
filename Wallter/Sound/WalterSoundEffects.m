//
// by najati 
// copyright Cyrus Innovation
//

#import "WalterSoundEffects.h"
#import "SimpleAudioEngine.h"

@implementation WalterSoundEffects {
	AudioPlayer *audio;
}

- (id)init:(AudioPlayer *)player {
	self = [super init];
	if (!self) return self;

	[CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
	[[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];

	audio = player;

	return self;
}

- (void)runningLeft {
}

- (void)runningRight {
}

- (void)wallJumping {
	[audio playEffect:@"DSOOF.WAV"];
}

- (void)groundJumping {
	[audio playEffect:@"DSOOF.WAV"];
}

- (void)falling {
}

- (void)running {
}

- (void)dying {
	[audio playEffect:@"DSPLDETH.WAV"];
}

- (void)attacking {
	[audio playEffect:@"DSPISTOL.WAV"];
}


@end