//
//  najati
//  copyright Cyrus Innovation 2012
//

#import "cocos2d.h"

#import "RunningLayer.h"
#import "SettingsLayer.h"
#import "SimpleButton.h"
#import "CGPoint_ops.h"

#import "IntroLayer.h"

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

	int padding = 15;

	CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"frames.png"];
	[self addChild:batchNode z:10];

	SimpleButton *goButton = [[SimpleButton alloc] init:@"go.up.png" downFrame:@"go.down.png" batch:batchNode];
	[goButton setReleaseCallbackTarget:self selector:@selector(playGame)];
	[goButton setPosition:cgp(size.width - padding - goButton.contentSize.width, padding)];
	[self addChild:goButton z:10];

	SimpleButton *settingsButton = [[SimpleButton alloc] init:@"settings.up.png" downFrame:@"settings.down.png" batch:batchNode];
	[settingsButton setReleaseCallbackTarget:self selector:@selector(goToSettings)];
	[settingsButton setPosition:cgp(padding, size.height - padding - settingsButton.contentSize.height)];
	[self addChild:settingsButton z:10];

	[self addChild:background];
}

- (void)playGame {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[RunningLayer scene] withColor:ccWHITE]];
}

- (void)goToSettings {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[SettingsLayer scene] withColor:ccWHITE]];
}

@end
