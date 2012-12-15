//
// by najati 
// copyright Cyrus Innovation
//

#import "SimpleButton.h"
#import "CGPoint_ops.h"

@implementation SimpleButton {
	CCSprite *sprite;

	id target;
	SEL selector;
}

-(id)init:(id) _target selector:(SEL)_selector {
	sprite = [[CCSprite alloc] initWithSpriteFrameName:@"gem1.png"];
	[sprite setScale:8];

	CGSize spriteSize = sprite.boundingBox.size;
	self = [super initWithColor:(ccColor4B) {0, 0, 0, 0} width:spriteSize.width height:spriteSize.height];
	if (!self) return self;

	self.isTouchEnabled = true;
	[sprite setPosition:cgp(spriteSize.width/2,spriteSize.height/2)];
	[self addChild:sprite];

	target = _target;
	selector = _selector;

	return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	if (![self isTouchInside:touch]) {
		return false;
	}
	
	[sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gem2.png"]];
	[target performSelector:selector];

	return true;
}

- (BOOL)isTouchInside:(UITouch *)touch {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	location = cgp_subtract(location, self.position);
	return CGRectContainsPoint(CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), location);
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	[sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gem1.png"]];
}

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

@end