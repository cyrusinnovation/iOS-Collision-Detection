//
// by najati
// copyright cyrus innovation
//

#import "cocos2d.h"

#import "ScoreLabel.h"
#import "Camera.h"
#import "AudioPlayer.h"
#import "AddBadGuyToStageObserver.h"
#import "WalterInTheSimulationTicker.h"
#import "ViewFactory.h"
#import "WalterSoundEffects.h"
#import "WalterViewAnimationChanger.h"
#import "WalterStuckednessTicker.h"
#import "CurrentSceneSpritesAndSounds.h"
#import "EnterAndExitTicker.h"
#import "SimpleButton.h"
#import "BlockOverTimeAction.h"
#import "GameOverLayer.h"

#import "RunningLayer.h"
#import "SimulationTiming.h"
#import "EndGameObserver.h"
#import "WalterWeaponImpl.h"

@implementation RunningLayer {
	CCAction *onEnterAction;
	SimulationTiming *simulationTiming;
}

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];

	WalterSimulationActorImpl *walterActor = [[WalterSimulationActorImpl alloc] initAt:cgp(30, 50)];
	Simulation *simulation = [[Simulation alloc] initFor:walterActor];
	WalterWeaponImpl *walterWeapon = [[WalterWeaponImpl alloc] initFor:walterActor in:simulation];
	Walter *walter = [Walter from:walterActor and:walterWeapon];

	Stage *stage = [[Stage alloc] init:simulation];
	stage.platformAddedObserver = ([[AddBadGuyToStageObserver alloc] init:simulation]);
	[stage prime];

	[simulation addTicker:[[WalterInTheSimulationTicker alloc] init:walter in:stage]];
	[simulation addTicker:[[WalterStuckednessTicker alloc] init:walter]];

	RunningLayer *layer = [[RunningLayer alloc] init:walter and:simulation audioPlayer:[[AudioPlayer alloc] init]];
	[scene addChild:layer];
	return scene;
}

- (id)init:(Walter *)walter and:(Simulation *)simulation audioPlayer:(AudioPlayer *)audioPlayer {
	self = ([self initLayer]);
	if (self == nil) return nil;

	[self scheduleUpdate];
	self.isTouchEnabled = YES;

	[audioPlayer playBackgroundMusic:@"music.mp3"];

	CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"frames.png"];
	[self addChild:batchNode z:10];

	simulationTiming = [[SimulationTiming alloc] init:0.01 scale:0.6 simulation:simulation];

	Camera *camera = [[Camera alloc] init:walter];
	[simulation addTicker:camera];
	camera.scale = 0.25;
	void (^zoomBlock)(float) = ^(float t) {
		camera.scale = 0.25 + 0.75 * t;
	};
	onEnterAction = [[BlockOverTimeAction alloc] init:zoomBlock duration:2];

	ViewFactory *viewFactory = [[ViewFactory alloc] init:camera batchNode:batchNode];

	ActorView *walterView = [viewFactory createWalterView:walter];
	[self addChild:walterView];

	void (^stopGame)() = ^() {
		[simulationTiming pause];
		[audioPlayer stopBackgroundMusic];
		[self transitionAfterPlayerDeath];
	};
	[walter.observer add:[[EndGameObserver alloc] init:stopGame]];
	[walter.observer add:[[WalterViewAnimationChanger alloc] init:walterView factory:viewFactory]];
	[walter.observer add:[[WalterSoundEffects alloc] init:audioPlayer]];

	CurrentSceneSpritesAndSounds *currentSceneListener = [[CurrentSceneSpritesAndSounds alloc] init:self and:viewFactory and:audioPlayer];
	[simulation addTicker:[[EnterAndExitTicker alloc] init:simulation camera:camera listener:currentSceneListener]];

	[self addChild:[[ScoreLabel alloc] initAt:cgp(75, 40)] z:INTERFACE_LAYER];

	[self initButtons:walter];

	return self;
}

- (void)onEnter {
	[super onEnter];
	[self runAction:onEnterAction];
}

- (void)initButtons:(Walter *)walter {
	CGSize s = [self currentWindowSize];

	SimpleButton *button = [[SimpleButton alloc] init:@"button.blue.png" downFrame:@"button.blue.down.png"];
	[button setDepressCallbackTarget:walter selector:@selector(jump)];
	[button setPosition:cgp(s.width - 80, 16)];
	[self addChild:button z:INTERFACE_LAYER];

	SimpleButton *attackButton = [[SimpleButton alloc] init:@"button.red.png" downFrame:@"button.red.down.png"];
	[attackButton setDepressCallbackTarget:walter selector:@selector(attack)];
	[attackButton setPosition:cgp(s.width - 80 * 2, 16)];
	[self addChild:attackButton z:INTERFACE_LAYER];
}

- (CCLayerColor *)initLayer {
	CGSize s = [self currentWindowSize];
	ccColor4B prettyBlue = (ccColor4B) {194, 233, 249, 255};
	return [super initWithColor:prettyBlue width:s.width height:s.height];
}

- (void)update:(ccTime)dt {
	[simulationTiming update:dt];
}

- (void)transitionAfterPlayerDeath {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOverLayer scene] withColor:ccBLACK]];
}

#pragma mark utils

- (CGSize)currentWindowSize {
	return [[CCDirector sharedDirector] winSize];
}

@end