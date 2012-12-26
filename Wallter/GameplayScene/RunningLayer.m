//
// by najati
// copyright cyrus innovation
//

#import "cocos2d.h"

#import "RunningLayer.h"

#import "StageView.h"
#import "AddBadGuyToStageObserver.h"
#import "BadGuyPolygonView.h"
#import "WalterViewAnimationChanger.h"
#import "SimpleButton.h"
#import "ActorView.h"
#import "AudioPlayer.h"
#import "WalterSoundEffects.h"
#import "AggregateWalterObserver.h"
#import "WalterStuckednessTicker.h"
#import "WalterInTheSimulationTicker.h"
#import "GameOverLayer.h"
#import "BlockOverTimeAction.h"
#import "ViewFactory.h"
#import "EnterAndExitTicker.h"
#import "BadGuySound.h"
#import "ElementViewMap.h"
#import "CurrentSceneListener.h"

@implementation RunningLayer {
	WalterSimulationActor *walter;
	WalterWeapon *walterWeapon;
	Simulation *simulation;

	ccTime timeBuffer;
	ccTime frameTime;
	float timeScale;

	BOOL transitioning;

	float score;
	CCLabelBMFont *scoreLabel;

	Camera *camera;

	AudioPlayer *audio;
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

	RunningLayer *layer = [[RunningLayer alloc] init:walter and:walterWeapon and:simulation];
	[scene addChild:layer];
	return scene;
}

- (id)init:(WalterSimulationActor *)_walterActor and:(WalterWeapon *)_walterWeapon and:(Simulation *)_simulation {
	self = ([self initLayer]);
	if (self == nil) return nil;

	[self scheduleUpdate];
	self.isTouchEnabled = YES;

	walter = _walterActor;
	walterWeapon = _walterWeapon;
	simulation = _simulation;

	CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"frames.png"];
	[self addChild:batchNode z:10];

	audio = [[AudioPlayer alloc] init];
	[audio playBackgroundMusic:@"music.mp3"];

	timeBuffer = 0;
	frameTime = 0.01;
	timeScale = 0.6;

	camera = [[Camera alloc] init:walter];
	camera.scale = 0.25;

	ViewFactory *viewFactory = [[ViewFactory alloc] init:camera batchNode:batchNode];

	ActorView *walterView = [viewFactory createWalterView:walter];
	[self addChild:walterView];

	WalterSoundEffects *walterSoundEffects = [[WalterSoundEffects alloc] init:audio];

	NSArray *observers = [NSArray arrayWithObjects:[[WalterViewAnimationChanger alloc] init:walterView factory:viewFactory], walterSoundEffects, nil];
	walter.observer = [[AggregateWalterObserver alloc] initWithObservers:observers];
	walterWeapon.observer = walterSoundEffects;

	[simulation addTicker:[[WalterStuckednessTicker alloc] init:walter]];

	id <ElementOnScreenObserver> currentSceneListener = [[CurrentSceneListener alloc] init:self and:viewFactory and:audio];
	[simulation addTicker:[[EnterAndExitTicker alloc] init:simulation camera:camera listener:currentSceneListener]];

	score = 0;
	[self setUpScoreLabel];

	[self initButtons];

	return self;
}

- (void)onEnter {
	[super onEnter];

	void (^zoomBlock)(float) = ^(float t) {
		camera.scale = 0.25 + 0.75 * t;
	};
	[self runAction:[[BlockOverTimeAction alloc] init:zoomBlock duration:2]];
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

- (void)setUpScoreLabel {
	scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"font.fnt"];
	scoreLabel.position = cgp(75, 40);
	[self addChild:scoreLabel z:INTERFACE_LAYER];
}

- (void)update:(ccTime)dt {
	timeBuffer += dt * timeScale;
	while (timeBuffer >= frameTime) {
		timeBuffer -= frameTime;
		[self updateInternal:frameTime];
	}
}

- (void)updateInternal:(ccTime)dt {
	if (transitioning) return;

	[simulation update:dt];
	[camera update];

	score += dt * 21;
	// TODO OPT don't update the score string every frame
	[scoreLabel setString:[NSString stringWithFormat:@"%d", (int) score]];

	if (walter.expired) {
		[self transitionAfterPlayerDeath];
	}
}

- (void)transitionAfterPlayerDeath {
	transitioning = true;

	[audio stopBackgroundMusic];

	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOverLayer scene] withColor:ccBLACK]];
}

#pragma mark utils

- (CGSize)currentWindowSize {
	return [[CCDirector sharedDirector] winSize];
}

@end