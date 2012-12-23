//
//  najati
//  copyright Cyrus Innovation 2012
//

#import "GameOverLayer.h"
#import "IntroLayer.h"
#import "CGPoint_ops.h"

@implementation GameOverLayer

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	GameOverLayer *layer = [GameOverLayer node];
	[scene addChild:layer];
	return scene;
}

- (void)onEnter {
	[super onEnter];
	CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background = [CCSprite spriteWithFile:@"wtf.png"];
	background.scaleX = size.height / background.contentSize.height;
	background.anchorPoint = cgp(0,0);
	[self addChild:background];

	self.isTouchEnabled = true;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[IntroLayer scene] withColor:ccWHITE]];
}

@end
