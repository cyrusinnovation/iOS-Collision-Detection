//
// by najati 
// copyright Cyrus Innovation
//

#import "SimpleButton.h"
#import "CGPoint_ops.h"

@implementation SimpleButton {
	CCSprite *sprite;

	id depressTarget;
	SEL depressSelector;

	id releaseTarget;
	SEL releaseSelector;

	NSString *upFrame;
	NSString *downFrame;

	BOOL _depressed;
}

@synthesize togglable;

- (id)init:(NSString *)_upFrame downFrame:(NSString *)_downFrame {
	upFrame = _upFrame;
	downFrame = _downFrame;

	sprite = [[CCSprite alloc] initWithSpriteFrameName:upFrame];

	CGSize spriteSize = sprite.boundingBox.size;
	self = [super initWithColor:(ccColor4B) {0, 0, 0, 0} width:spriteSize.width height:spriteSize.height];
	if (!self) return self;

	self.isTouchEnabled = true;
	[sprite setPosition:cgp(spriteSize.width / 2, spriteSize.height / 2)];
	[self addChild:sprite];

	_depressed = false;
	togglable = false;

	return self;
}

- (void)setDepressCallbackTarget:(id)_target selector:(SEL)_selector {
	depressTarget = _target;
	depressSelector = _selector;
}

- (void)setReleaseCallbackTarget:(id)_target selector:(SEL)_selector {
	releaseTarget = _target;
	releaseSelector = _selector;
}

- (BOOL)depressed {
	return _depressed;
}

- (void)setDepressed:(BOOL)depressed {
	if (depressed) {
		[self depress];
	} else {
		[self rrelease];
	}
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	if (![self isTouchInside:touch]) {
		return false;
	}

	if (togglable) {
		if (self.depressed) {
			[self rrelease];
		} else {
			[self depress];
		}
	} else {
		[self depress];
	}

	return true;
}

- (void)depress {
	if (_depressed) return;
	_depressed = true;

	[sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:downFrame]];

	if (depressTarget) {
		[depressTarget performSelector:depressSelector];
	}
}

- (void)rrelease {
	[self rrelease:true];
}

- (void)rrelease:(BOOL) callCallback {
	if (!_depressed) return;
	_depressed = false;

	[sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:upFrame]];

	if (callCallback && releaseTarget) {
		[releaseTarget performSelector:releaseSelector];
	}
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	if (![self isTouchInside:touch]) {
		return;
	}

	if (!togglable) {
		[self rrelease];
	}
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	if (!togglable && ![self isTouchInside:touch]) {
		[self rrelease:false];
	}
}

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)isTouchInside:(UITouch *)touch {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	location = cgp_subtract(location, self.position);
	return CGRectContainsPoint(CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), location);
}

@end