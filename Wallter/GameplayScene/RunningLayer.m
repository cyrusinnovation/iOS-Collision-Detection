//
// by najati
// copyright cyrus innovation
//

#import "RunningLayer.h"

#import "Stage.h"

#import "StageView.h"
#import "Simulation.h"
#import "MeleeAttack.h"
#import "AddBadGuyToStageObserver.h"
#import "BadGuyPolygonView.h"
#import "WalterViewAnimationChanger.h"
#import "SimpleButton.h"
#import "ActorView.h"
#import "AudioPlayer.h"
#import "WalterSoundEffects.h"
#import "AggregateWalterObserver.h"
#import "WalterWeapon.h"
#import "WalterStuckednessTicker.h"
#import "WalterInTheSimulationTicker.h"
#import "GameOverLayer.h"
#import "BlockOverTimeAction.h"
#import "ViewFactory.h"
#import "EnterAndExitTicker.h"
#import "BadGuySound.h"
#import "ElementViewMap.h"

@implementation RunningLayer {
	WalterSimulationActor *walter;
	WalterWeapon *walterWeapon;
	Simulation *simulation;

	ccTime timeBuffer;
	ccTime frameTime;

	CCLabelBMFont *scoreLabel;

	float score;

	Camera *camera;

	BOOL transitioning;
	CCSpriteBatchNode *batchNode;

	AudioPlayer *audio;
	ViewFactory *viewFactory;
	float timeScale;

	ElementViewMap *elementViews;
	BadGuySound *badGuySound;
}

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	RunningLayer *layer = [RunningLayer node];
	[scene addChild:layer];
	return scene;
}

- (id)init{
	self = ([self initLayer]);
	if (self == nil) return nil;

	[self scheduleUpdate];
	self.isTouchEnabled = YES;

	[self initSimulation];

	elementViews = [[ElementViewMap alloc] init];

	batchNode = [CCSpriteBatchNode batchNodeWithFile:@"frames.png"];
	[self addChild:batchNode z:10];

	audio = [[AudioPlayer alloc] init];
	[audio playBackgroundMusic:@"music.mp3"];

	timeBuffer = 0;
	frameTime = 0.01;
	timeScale = 0.6;

	camera = [[Camera alloc] init:walter];
	camera.scale = 0.25;

	viewFactory = [[ViewFactory alloc] init:camera batchNode:batchNode];

	ActorView *walterView = [viewFactory createWalterView:walter];
	[self addChild:walterView];

	NSArray *observers = [NSArray arrayWithObjects:[[WalterViewAnimationChanger alloc] init:walterView factory:viewFactory], [[WalterSoundEffects alloc] init:audio], nil];
	walter.observer = [[AggregateWalterObserver alloc] initWithObservers:observers];

	walterWeapon.observer = ([[WalterSoundEffects alloc] init:audio]);

	[simulation addTicker:[[WalterStuckednessTicker alloc] init:walter]];
	[simulation addTicker:[[EnterAndExitTicker alloc] init:simulation camera:camera listener:self]];

	score = 0;
	[self setUpScoreLabel];

	badGuySound = [[BadGuySound alloc] init:audio];
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

- (void)initSimulation {
	walter = [[WalterSimulationActor alloc] initAt:cgp(30, 50)];
	simulation = [[Simulation alloc] initFor:walter];
	walterWeapon = [[WalterWeapon alloc] initFor:walter in:simulation];

	Stage *stage = [[Stage alloc] init:simulation];
	stage.platformAddedObserver = ([[AddBadGuyToStageObserver alloc] init:simulation]);
	[stage prime];

	[simulation addTicker:[[WalterInTheSimulationTicker alloc] init:walter in:stage]];

//	walter = [[Walter alloc] init:walterActor weapon:walterWeapon];
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

- (void)elementEnteredView:(id <BoundedPolygon>)platform {
	ActorView *view;
	if ([platform isKindOfClass:[Platform class]]) {
		view = [viewFactory createPlatformView:(Platform *) platform parent:self];
	} else if ([platform isKindOfClass:[BadGuy class]]) {
		BadGuy *badGuy = (BadGuy *) platform;
		view = [viewFactory createBadGuyView:badGuy];
		badGuy.observer = badGuySound;
	} else if ([platform isKindOfClass:[MeleeAttack class]]) {
		view = [viewFactory createMeleeAttackView:(MeleeAttack *) platform];
	}

	if (!view) return;

	[self addChild:view];
	[elementViews add:view of:platform];
}

- (void)elementLeftView:(id <BoundedPolygon>)platform {
	BOOL isElementOfKnownClass = [platform isKindOfClass:[Platform class]] ||
			[platform isKindOfClass:[BadGuy class]] ||
			[platform isKindOfClass:[MeleeAttack class]];
	if (!isElementOfKnownClass)
		return;

	[self removeChild:[elementViews removeViewFor:platform] cleanup:true];
}


@end