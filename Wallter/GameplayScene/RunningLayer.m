//
// by najati
// copyright cyrus innovation
//

#import "RunningLayer.h"

#import "Stage.h"

#import "StageView.h"
#import "Simulation.h"
#import "MeleeAttack.h"
#import "SettingsLayer.h"
#import "HighScoresLayer.h"
#import "HighScores.h"
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

	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"frames.plist"];
	batchNode = [CCSpriteBatchNode batchNodeWithFile:@"frames.png"];
	[self addChild:batchNode z:10];

	buffer = 0;
	frameTime = 0.01;
	[self initStage];
	[self initButtons];

	audio = [[AudioPlayer alloc] init];
	[audio playBackgroundMusic:@"music.mp3"];

	return self;
}

- (void)initButtons {
	CGSize s = [self currentWindowSize];

	SimpleButton *button = [[SimpleButton alloc] init:walter selector:@selector(jump) frame:@"button.blue.png" downFrame:@"button.blue.down.png"];
	[button setPosition:cgp(s.width - 80, 16)];
	[self addChild:button z:INTERFACE_LAYER];

	SimpleButton *attackButton = [[SimpleButton alloc] init:walterWeapon selector:@selector(attack) frame:@"button.red.png" downFrame:@"button.red.down.png"];
	[attackButton setPosition:cgp(s.width - 80*2, 16)];
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

	stage = [[Stage alloc] init];
	walter = [[Walter alloc] initAt:cgp(30, 50)];
	simulation = [[Simulation alloc] initFor:walter in:stage];
	walterWeapon = [[WalterWeapon alloc] initFor:walter in:simulation];
	simulation.simulationObserver = self;
	
	camera = [[Camera alloc] init:walter];

	AddBadGuyToStageObserver *addBadGuyToStageObserver = [[AddBadGuyToStageObserver alloc] init:simulation];
	stage.platformAddedObserver = addBadGuyToStageObserver;

	[self addChild:[[StageView alloc] init:stage following:camera]];
	WalterView *walterView = [[WalterView alloc] init:walter camera:camera batchNode:batchNode];
	[self addChild:walterView];

	WalterSoundEffects *walterSoundEffects = [[WalterSoundEffects alloc] init];
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

	CCScene *scene;
	if ([HighScores isHighScore:score]) {
		// TODO
		scene = [SettingsLayer scene];
	} else {
		scene = [HighScoresLayer scene];
	}
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccBLACK]];
}

#pragma mark SimulationObserver

-(void)addedCharacter:(id<BoundedPolygon, SimulationActor>) character {
	if (![character isKindOfClass:[BadGuy class]]) return;
	[self addChild:[[BadGuyView alloc] init:character camera:camera batchNode:batchNode]];
}

-(void)addedAttack:(id <BoundedPolygon, SimulationActor>) attack {
	if (![attack isKindOfClass:[MeleeAttack class]]) return;
	[self addChild:[[MeleeAttackView alloc] init:attack following:camera batchNode:batchNode]];
}

#pragma mark utils

- (CGSize)currentWindowSize {
	return [[CCDirector sharedDirector] winSize];
}


@end