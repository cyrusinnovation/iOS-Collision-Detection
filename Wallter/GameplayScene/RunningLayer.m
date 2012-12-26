//
// by najati
// copyright cyrus innovation
//

#import "cocos2d.h"

#import "ScoreLabel.h"
#import "Camera.h"
#import "WalterWeapon.h"

#import "AudioPlayer.h"
#import "AddBadGuyToStageObserver.h"
#import "WalterInTheSimulationTicker.h"
#import "ViewFactory.h"
#import "WalterSoundEffects.h"
#import "WalterViewAnimationChanger.h"
#import "AggregateWalterObserver.h"
#import "WalterStuckednessTicker.h"
#import "CurrentSceneSpritesAndSounds.h"
#import "EnterAndExitTicker.h"
#import "SimpleButton.h"
#import "BlockOverTimeAction.h"
#import "GameOverLayer.h"

#import "RunningLayer.h"

@implementation RunningLayer {
	WalterSimulationActor *walter;
	WalterWeapon *walterWeapon;
	Simulation *simulation;

	ccTime timeBuffer;
	ccTime frameTime;
	float timeScale;

	BOOL shouldPauseUpdate;

	AudioPlayer *audioPlayer;
	
	CCAction *onEnterAction;
}

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];

	WalterSimulationActor *walter = [[WalterSimulationActor alloc] initAt:cgp(30, 50)];
	Simulation *simulation = [[Simulation alloc] initFor:walter];
	WalterWeapon *walterWeapon = [[WalterWeapon alloc] initFor:walter in:simulation];

	Stage *stage = [[Stage alloc] init:simulation];
	stage.platformAddedObserver = ([[AddBadGuyToStageObserver alloc] init:simulation]);
	[stage prime];

	[simulation addTicker:[[WalterInTheSimulationTicker alloc] init:walter in:stage]];
	[simulation addTicker:[[WalterStuckednessTicker alloc] init:walter]];

	RunningLayer *layer = [[RunningLayer alloc] init:walter and:walterWeapon and:simulation audioPlayer:[[AudioPlayer alloc] init]];
	[scene addChild:layer];
	return scene;
}

- (id)init:(WalterSimulationActor *)_walterActor and:(WalterWeapon *)_walterWeapon and:(Simulation *)_simulation audioPlayer:(AudioPlayer *)_audioPlayer {
	self = ([self initLayer]);
	if (self == nil) return nil;

	[self scheduleUpdate];
	self.isTouchEnabled = YES;

	walter = _walterActor;
	walterWeapon = _walterWeapon;
	simulation = _simulation;

	audioPlayer = _audioPlayer;
	[audioPlayer playBackgroundMusic:@"music.mp3"];

	CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"frames.png"];
	[self addChild:batchNode z:10];

	timeBuffer = 0;
	frameTime = 0.01;
	timeScale = 0.6;

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

	WalterSoundEffects *walterSoundEffects = [[WalterSoundEffects alloc] init:audioPlayer];

	NSArray *observers = [NSArray arrayWithObjects:[[WalterViewAnimationChanger alloc] init:walterView factory:viewFactory], walterSoundEffects, nil];
	walter.observer = [[AggregateWalterObserver alloc] initWithObservers:observers];
	walterWeapon.observer = walterSoundEffects;

	CurrentSceneSpritesAndSounds *currentSceneListener = [[CurrentSceneSpritesAndSounds alloc] init:self and:viewFactory and:audioPlayer];
	[simulation addTicker:[[EnterAndExitTicker alloc] init:simulation camera:camera listener:currentSceneListener]];

	[self addChild:[[ScoreLabel alloc] initAt:cgp(75, 40)] z:INTERFACE_LAYER];

	[self initButtons];

	return self;
}

- (void)onEnter {
	[super onEnter];

	[self runAction:onEnterAction];
}

- (void)initButtons {
	CGSize s = [self currentWindowSize];

	SimpleButton *button = [[SimpleButton alloc] init:@"button.blue.png" downFrame:@"button.blue.down.png"];
	[button setDepressCallbackTarget:walter selector:@selector(jump)];
	[button setPosition:cgp(s.width - 80, 16)];
	[self addChild:button z:INTERFACE_LAYER];

	SimpleButton *attackButton = [[SimpleButton alloc] init:@"button.red.png" downFrame:@"button.red.down.png"];
	[attackButton setDepressCallbackTarget:walterWeapon selector:@selector(attack)];
	[attackButton setPosition:cgp(s.width - 80 * 2, 16)];
	[self addChild:attackButton z:INTERFACE_LAYER];
}

- (CCLayerColor *)initLayer {
	CGSize s = [self currentWindowSize];
	ccColor4B prettyBlue = (ccColor4B) {194, 233, 249, 255};
	return [super initWithColor:prettyBlue width:s.width height:s.height];
}

- (void)update:(ccTime)dt {
	timeBuffer += dt * timeScale;
	while (timeBuffer >= frameTime) {
		timeBuffer -= frameTime;
		[self updateInternal:frameTime];
	}
}

- (void)updateInternal:(ccTime)dt {
	if (shouldPauseUpdate) return;

	[simulation update:dt];

	if (walter.expired) {
		[self transitionAfterPlayerDeath];
	}
}

- (void)transitionAfterPlayerDeath {
	shouldPauseUpdate = true;

	[audioPlayer stopBackgroundMusic];

	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOverLayer scene] withColor:ccBLACK]];
}

#pragma mark utils

- (CGSize)currentWindowSize {
	return [[CCDirector sharedDirector] winSize];
}

@end