//
// Created by najati on 9/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GuyController.h"
#import "MeleeAttackView.h"
#import "GuyControllerEndpoint.h"

@implementation GuyController {
	NSObject <GuyControllerEndpoint> *endpoint;

	CGPoint touchStart;
	CGPoint touchMove;
	bool touching;
	float touchTime;
	bool attackFromTouch;
	float attack_delay;
}

+ (GuyController *)from:(NSObject <GuyControllerEndpoint> *)guy attackDelay:(float) delay {
	return [[GuyController alloc] initFor:guy attackDelay:delay];
}

- (id)initFor:(NSObject <GuyControllerEndpoint> *)guy attackDelay:(float)_attack_delay {
	if (self = [super init]) {
		endpoint = guy;
		attack_delay = _attack_delay;

		touching = false;
		touchTime = -1;
	}
	return self;
}

- (void)touchStarted:(CGPoint)location {
	touchMove = touchStart = location;
	touching = true;
}

- (void)touchMoved:(CGPoint)location {
	touchMove = location;
	CGPoint swipe = cgp_subtract(touchMove, touchStart);

	float length = cgp_length(swipe);

	if (length > 20) {
		if (swipe.y > 3) {
			if (swipe.x < 0) {
				[endpoint jumpLeft];
			} else if (swipe.x > 0) {
				[endpoint jumpRight];
			}
		}
	}
}

- (void)touchEnded:(CGPoint)location {
	if (!attackFromTouch) {
		CGPoint touchEnd = location;
		CGPoint swipe = cgp_subtract(touchEnd, touchStart);

		float length = cgp_length(swipe);
		if (length <= 20) {
			[endpoint attack];
		}
	}

	touching = false;
	touchTime = 0;
	attackFromTouch = false;
}
- (void)update:(float)dt {
	if (touching) {
		touchTime += dt;

		if (!attackFromTouch && touchTime > attack_delay) {
			CGPoint swipe = cgp_subtract(touchMove, touchStart);
			float length = cgp_length(swipe);
			if (length < 10) {
				[endpoint attack];
				attackFromTouch = true;
			}
		}
	}
}

@end