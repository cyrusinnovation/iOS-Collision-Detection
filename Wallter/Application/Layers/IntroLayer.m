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

	CCSprite *background;

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		background = [CCSprite spriteWithFile:@"instructions.png"];
		background.scale = 2; // TODO maybe only do this on retina display
	} else {
		background = [CCSprite spriteWithFile:@"instructions~ipad.png"];
	}
	background.position = ccp(size.width / 2, size.height / 2);

	[self addChild:background];
}

-(void)onEnterTransitionDidFinish {
	[self scheduleOnce:@selector(makeTransition:) delay:0.5];
}

- (void)makeTransition:(ccTime)dt {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[RunningLayer scene] withColor:ccWHITE]];
}

@end
