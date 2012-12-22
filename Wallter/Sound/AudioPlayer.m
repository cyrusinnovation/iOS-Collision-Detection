//
// by najati 
// copyright Cyrus Innovation
//

#import "AudioPlayer.h"
#import "SimpleAudioEngine.h"
#import "Settings.h"

@implementation AudioPlayer {
	SimpleAudioEngine *audio;
}

@synthesize playingSoundEffects;
@synthesize playingMusic;

-(id) init {
	self = [super init];
	if (!self) return self;

	audio = [SimpleAudioEngine sharedEngine];
	[audio preloadBackgroundMusic:@"music.mp3"];
	[audio preloadEffect:@"DSOOF.WAV"];
	[audio preloadEffect:@"DSPISTOL.WAV"];
	[audio preloadEffect:@"DSPLDETH.WAV"];
	[audio preloadEffect:@"DSPODTH3.WAV"];

	[audio setBackgroundMusicVolume:0.75f];

	playingMusic = [[Settings instance] musicOn];
	playingSoundEffects = [[Settings instance] soundEffectsOn];

	return self;
}

- (void)playEffect:(NSString *)string {
	if (playingSoundEffects) {
		[audio playEffect:string];
	}	
}

- (void)playBackgroundMusic:(NSString *)string {
	if (playingMusic) {
		[audio stopBackgroundMusic];
		[audio playBackgroundMusic:string loop:true];
	}
}

- (void)stopBackgroundMusic {
	[audio stopBackgroundMusic];
}

@end