//
// Created by najati on 12/14/12.
//

#import "AddBadGuyToStageObserver.h"

#import "Platform.h"
#import "BadGuy.h"
#import "AudioPlayer.h"

@implementation AddBadGuyToStageObserver {
	Simulation *simulation;
	AudioPlayer *audio;
}

- (id)init:(Simulation *)_simulation {
	self = [super init];
	if (self == nil) return nil;
	
	simulation = _simulation;

	return self;
}

- (void)addedPlatform:(Platform *)platform goingRight:(BOOL)goingRight {
	int numberOfBaddies = rand() % 4;
	if (numberOfBaddies == 0) return;

	float x = platform.center;
	float y = platform.top;

	if (numberOfBaddies < 3) {
		[self addBadGuy:cgp(x, y) facingRight:!goingRight];
	} else {
		[self addBadGuy:cgp(x - 80, y) facingRight:!goingRight];
		[self addBadGuy:cgp(x + 80, y) facingRight:!goingRight];
	}
}

- (void)addBadGuy:(CGPoint)location facingRight:(bool)facingRight {
	BadGuy *badGuy = [[BadGuy alloc] init:location facingRight:facingRight];
	[simulation addEnemy:badGuy];
}


@end