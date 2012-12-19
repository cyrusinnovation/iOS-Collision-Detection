//
// Created by najati on 12/14/12.
//


#import "AddBadGuyToStageObserver.h"

#import "Platform.h"
#import "BadGuy.h"
#import "Simulation.h"
#import "CharacterAddedObserver.h"

@implementation AddBadGuyToStageObserver {
	Simulation *simulation;
}

@synthesize characterAddedObserver;

- (id)init:(Simulation *)_simulation{
	self = [super init];
	if (self == nil) return nil;
	
	simulation = _simulation;
	return self;
}

- (void)addedPlatform:(Platform *)platform goingRight:(Boolean)goingRight {
	int numberOfBaddies = rand() % 4;
	if (numberOfBaddies == 0) return;

	float x = platform.center;
	float y = platform.top;

	if (numberOfBaddies < 3) {
		[self addBadguy:cgp(x, y) facingRight:!goingRight];
	} else {
		[self addBadguy:cgp(x - 80, y) facingRight:!goingRight];
		[self addBadguy:cgp(x + 80, y) facingRight:!goingRight];
	}
}

- (void)addBadguy:(CGPoint)location facingRight:(bool)facingRight {
	BadGuy *badGuy = [[BadGuy alloc] init:location facingRight:facingRight];
	[simulation addEnemy:badGuy];
	[characterAddedObserver addedCharacter:badGuy];
}

@end