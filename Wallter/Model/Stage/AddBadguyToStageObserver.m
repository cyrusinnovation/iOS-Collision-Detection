//
// Created by najati on 12/14/12.
//
// To change the template use AppCode | Preferences | File Templates.
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

- (void)addedPlatform:(Platform *)platform {
	int numberOfBaddies = rand() % 4;
	if (numberOfBaddies == 0) return;

	float x = platform.center;
	float y = platform.top;

	if (numberOfBaddies < 3) {
		[self addBadguy:cgp(x, y)];
	} else {
		[self addBadguy:cgp(x - 80, y)];
		[self addBadguy:cgp(x + 80, y)];
	}
}

- (void)addBadguy:(CGPoint)location {
	BadGuy *badGuy = [[BadGuy alloc] init:location];
	[simulation addEnemy:badGuy];
	[characterAddedObserver addedCharacter:badGuy];
}

@end