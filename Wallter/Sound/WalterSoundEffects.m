//
// by najati 
// copyright Cyrus Innovation
//

#import "WalterSoundEffects.h"
#import "SimpleAudioEngine.h"

@implementation WalterSoundEffects {
	AudioPlayer *audio;
}

- (id)init {
	self = [super init];
	if (!self) return self;

	[CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
	[[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];

	audio = [SimpleAudioEngine sharedEngine];

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

- (void)attacking:(MeleeAttack *)attack {
	[audio playEffect:@"DSPISTOL.WAV"];
}


@end