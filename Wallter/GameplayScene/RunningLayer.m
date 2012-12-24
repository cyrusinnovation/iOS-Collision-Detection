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
#import "BadGuyView.h"
#import "MeleeAttackView.h"
#import "AudioPlayer.h"
#import "WalterSoundEffects.h"
#import "AggregateWalterObserver.h"
#import "WalterWeapon.h"
#import "WalterStuckednessTicker.h"
#import "WalterDeathFallTicker.h"
#import "GameOverLayer.h"
#import "BlockOverTimeAction.h"
#import "Platform.h"

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

	batchNode = [CCSpriteBatchNode batchNodeWithFile:@"frames.png"];
	[self addChild:batchNode z:10];

	audio = [[AudioPlayer alloc] init];
	[audio playBackgroundMusic:@"music.mp3"];

	buffer = 0;
	frameTime = 0.01;
	[self initStage];
	[self initButtons];

	void (^zoomBlock)(float) = ^(float t) {
		camera.scale = 0.25 + 0.75 * t;
	};
	[self runAction:[[BlockOverTimeAction alloc] init:zoomBlock duration:4]];

	return self;
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
	// TODO we probably shouldn't actually do this, maybe?
	[self removeAllChildrenWithCleanup:true];
	[self addChild:batchNode];

	score = 0;

	walter = [[Walter alloc] initAt:cgp(30, 50)];
	simulation = [[Simulation alloc] initFor:walter];
	stage = [[Stage alloc] init:simulation];
	walterWeapon = [[WalterWeapon alloc] initFor:walter in:simulation];
	simulation.simulationObserver = self;

	camera = [[Camera alloc] init:walter];

	AddBadGuyToStageObserver *addBadGuyToStageObserver = [[AddBadGuyToStageObserver alloc] init:simulation audio:audio];
	stage.platformAddedObserver = addBadGuyToStageObserver;

	[self addChild:[[StageView alloc] init:simulation following:camera]];
	WalterView *walterView = [[WalterView alloc] init:walter camera:camera batchNode:batchNode];
	[self addChild:walterView];

	WalterSoundEffects *walterSoundEffects = [[WalterSoundEffects alloc] init:audio];
	NSArray *observers = [NSArray arrayWithObjects:walterView, walterSoundEffects, nil];
	walter.observer = [[AggregateWalterObserver alloc] initWithObservers:observers];

	walterWeapon.observer = walterSoundEffects;

	[simulation addTicker:[[WalterStuckednessTicker alloc] init:walter]];
	[simulation addTicker:[[WalterDeathFallTicker alloc] init:walter in:stage]];

	[stage prime];

	[self setUpScoreLabel];
}

- (void)setUpScoreLabel {
	scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"font.fnt"];
	scoreLabel.position = cgp(75, 40);
	[self addChild:scoreLabel z:INTERFACE_LAYER];
}

- (void)update:(ccTime)dt {
	buffer += dt * 0.6;
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

	if (walter.isExpired) {
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
	if (![character isKindOfClass:[BadGuy class]]) return;
	[self addChild:[[BadGuyView alloc] init:character camera:camera batchNode:batchNode]];
}

- (void)addedAttack:(id <BoundedPolygon, SimulationActor>)attack {
	if (![attack isKindOfClass:[MeleeAttack class]]) return;
	[self addChild:[[MeleeAttackView alloc] init:attack following:camera batchNode:batchNode]];
}

- (void)addedEnvironmentElement:(id <BoundedPolygon>)element {
	if (![element isKindOfClass:[Platform class]]) return;
//	[self addChild:[[PlatformView alloc] init:element following:camera batchNode:batchNode]];
}


#pragma mark utils

- (CGSize)currentWindowSize {
	return [[CCDirector sharedDirector] winSize];
}


@end