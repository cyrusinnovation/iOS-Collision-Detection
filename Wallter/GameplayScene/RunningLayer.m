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
#import "WalterView.h"
#import "SimpleButton.h"
#import "ActorView.h"
#import "AudioPlayer.h"
#import "WalterSoundEffects.h"
#import "AggregateWalterObserver.h"
#import "WalterWeapon.h"
#import "WalterStuckednessTicker.h"
#import "WalterDeathFallTicker.h"
#import "GameOverLayer.h"
#import "BlockOverTimeAction.h"
#import "Platform.h"
#import "ViewFactory.h"
#import "EnterAndExitTicker.h"
#import "BadGuySound.h"
#import "ElementViewMap.h"

@implementation RunningLayer {
	Stage *stage;
	Walter *walter;
	Simulation *simulation;

	ccTime buffer;
	ccTime frameTime;

	CCLabelBMFont *scoreLabel;

	float score;

	Camera *camera;

	BOOL transitioning;
	CCSpriteBatchNode *batchNode;

	AudioPlayer *audio;
	WalterWeapon *walterWeapon;
	ViewFactory *viewFactory;
	float timeScale;

	ElementViewMap *elementViews;
}

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	RunningLayer *layer = [RunningLayer node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
	self = ([self initLayer]);
	if (self == nil) return nil;

	[self scheduleUpdate];
	self.isTouchEnabled = YES;

	elementViews = [[ElementViewMap alloc] init];

	batchNode = [CCSpriteBatchNode batchNodeWithFile:@"frames.png"];
	[self addChild:batchNode z:10];

	audio = [[AudioPlayer alloc] init];
	[audio playBackgroundMusic:@"music.mp3"];

	buffer = 0;
	frameTime = 0.01;
	timeScale = 0.6;
	[self initStage];
	[self initButtons];

	return self;
}

- (void)onEnter {
	[super onEnter];

	void (^zoomBlock)(float) = ^(float t) {
		camera.scale = 0.25 + 0.75 * t;
	};
	[self runAction:[[BlockOverTimeAction alloc] init:zoomBlock duration:4]];
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

- (void)initStage {

	walter = [[Walter alloc] initAt:cgp(30, 50)];
	simulation = [[Simulation alloc] initFor:walter];

	stage = [[Stage alloc] init:simulation];
	AddBadGuyToStageObserver *addBadGuyToStageObserver = [[AddBadGuyToStageObserver alloc] init:simulation];
	stage.platformAddedObserver = addBadGuyToStageObserver;

	walterWeapon = [[WalterWeapon alloc] initFor:walter in:simulation];
	simulation.simulationObserver = self;

	camera = [[Camera alloc] init:walter];
	camera.scale = 0.25;
	// TODO yucky that this in here
	viewFactory = [[ViewFactory alloc] init:camera batchNode:batchNode];

	ActorView *walterView = [viewFactory createWalterView:walter];
	[self addChild:walterView];

	NSArray *observers = [NSArray arrayWithObjects:[[WalterView alloc] init:walterView factory:viewFactory], [[WalterSoundEffects alloc] init:audio], nil];
	walter.observer = [[AggregateWalterObserver alloc] initWithObservers:observers];

	walterWeapon.observer = ([[WalterSoundEffects alloc] init:audio]);

	[simulation addTicker:[[WalterStuckednessTicker alloc] init:walter]];
	[simulation addTicker:[[WalterDeathFallTicker alloc] init:walter in:stage]];
	[simulation addTicker:[[EnterAndExitTicker alloc] init:simulation camera:camera listener:self]];

	score = 0;
	[self setUpScoreLabel];

	addBadGuyToStageObserver.observer = [[BadGuySound alloc] init:audio];

	[stage prime];
}

- (void)setUpScoreLabel {
	scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"font.fnt"];
	scoreLabel.position = cgp(75, 40);
	[self addChild:scoreLabel z:INTERFACE_LAYER];
}

- (void)update:(ccTime)dt {
	buffer += dt * timeScale;
	while (buffer >= frameTime) {
		buffer -= frameTime;
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

#pragma mark SimulationObserver

- (void)addedCharacter:(id <BoundedPolygon, SimulationActor>)character {
}

- (void)addedAttack:(id <BoundedPolygon, SimulationActor>)attack {
}

- (void)addedEnvironmentElement:(id <BoundedPolygon, SimulationActor>)element {
}


#pragma mark utils

- (CGSize)currentWindowSize {
	return [[CCDirector sharedDirector] winSize];
}

- (void)platformEnteredView:(id <BoundedPolygon>)element {
	ActorView *view;
	if ([element isKindOfClass:[Platform class]]) {
		view = [viewFactory createPlatformView:(Platform *) element parent:self];
	} else if ([element isKindOfClass:[BadGuy class]]) {
		view = [viewFactory createBadGuyView:(BadGuy *) element];
	} else if ([element isKindOfClass:[MeleeAttack class]]) {
		view = [viewFactory createMeleeAttackView:(MeleeAttack *) element];
	}

	if (!view) return;

	[self addChild:view];
	[elementViews add:view of:element];
}

- (void)platformLeftView:(id <BoundedPolygon>)element {
	BOOL isElementOfKnownClass = [element isKindOfClass:[Platform class]] ||
			[element isKindOfClass:[BadGuy class]] ||
			[element isKindOfClass:[MeleeAttack class]];
	if (!isElementOfKnownClass)
		return;

	[self removeChild:[elementViews removeViewFor:element] cleanup:true];
}


@end