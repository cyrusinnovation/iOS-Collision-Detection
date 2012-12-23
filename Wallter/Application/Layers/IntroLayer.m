//
//  najati
//  copyright Cyrus Innovation 2012
//

#import "IntroLayer.h"
#import "RunningLayer.h"
#import "SettingsLayer.h"

#pragma mark - IntroLayer

@implementation IntroLayer

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	IntroLayer *layer = [IntroLayer node];
	[scene addChild:layer];
	return scene;
}

- (void)onEnter {
	[super onEnter];
	CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background = [CCSprite spriteWithFile:@"title.jpg"];
	background.scale = size.height / background.contentSize.height;
	background.anchorPoint = cgp(0, 0);

	[self addChild:background];
}

- (void)makeTransition:(ccTime)dt {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[SettingsLayer scene] withColor:ccWHITE]];
}

@end
