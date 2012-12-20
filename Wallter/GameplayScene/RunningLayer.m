//
//  by najati
//  copyright cyrus innovation
//


#import "RunningLayer.h"

#import "StageView.h"
#import "Simulation.h"
#import "MeleeAttack.h"
#import "MeleeAttackPolygonView.h"
#import "SettingsLayer.h"
#import "HighScoresLayer.h"
#import "HighScores.h"
#import "AddBadGuyToStageObserver.h"
#import "BadGuyPolygonView.h"
#import "WalterView.h"
#import "SimpleButton.h"
#import "BadGuyView.h"
#import "MeleeAttackView.h"
#import "SimpleAudioEngine.h"

@implementation RunningLayer {
	Stage *stage;
	Walter *walter;
	Simulation *simulation;

	ccTime buffer;
	ccTime frameTime;
	CGPoint waltersLocation;
	ccTime timeAtCurrentPosition;

	CCLabelBMFont *scoreLabel;

	float score;

	Camera *drawOffset;

	BOOL transitioning;
	CCSpriteBatchNode *batchNode;

	SimpleAudioEngine *audio;
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

	CGSize s = [self currentWindowSize];

	SimpleButton *button = [[SimpleButton alloc] init:self selector:@selector(jump) frame:@"button.blue.png" downFrame:@"button.blue.down.png"];
	[button setPosition:cgp(s.width - 80, 16)];
	[self addChild:button z:INTERFACE_LAYER];

	SimpleButton *attackButton = [[SimpleButton alloc] init:self selector:@selector(attack) frame:@"button.red.png" downFrame:@"button.red.down.png"];
	[attackButton setPosition:cgp(s.width - 80*2, 16)];
	[self addChild:attackButton z:INTERFACE_LAYER];

	[CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
	[[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
	audio = [SimpleAudioEngine sharedEngine];
	[audio preloadEffect:@"DSOOF.WAV"];
	[audio preloadEffect:@"DSPISTOL.WAV"];
	[audio preloadEffect:@"DSPLDETH.WAV"];
	[audio preloadEffect:@"DSPODTH3.WAV"];

	return self;
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

	waltersLocation = cgp(30, 50);
	timeAtCurrentPosition = 0;
	score = 0;

	walter = [[Walter alloc] initAt:waltersLocation];

	drawOffset = [[Camera alloc] init:walter];

	stage = [[Stage alloc] init];

	simulation = [[Simulation alloc] initFor:walter in:stage];

	AddBadGuyToStageObserver *addBadguyToStageObserver = [[AddBadGuyToStageObserver alloc] init:simulation];
	addBadguyToStageObserver.characterAddedObserver = self;
	stage.platformAddedObserver = addBadguyToStageObserver;

	[stage prime];

	[self addChild:[[StageView alloc] init:stage following:drawOffset]];
	WalterView *walterView = [[WalterView alloc] init:walter camera:drawOffset batchNode:batchNode];
	[self addChild:walterView];

	walter.walterObserver = walterView;

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
	[drawOffset update];

	score += fabs(walter.location.x - waltersLocation.x) * 0.07;
	// TODO OPT don't update the score string every frame
	[scoreLabel setString:[NSString stringWithFormat:@"%d", (int) score]];

	if (walter.location.y < stage.deathHeight || walter.isExpired) {
		[self transitionAfterPlayerDeath];
		[audio playEffect:@"DSPLDETH.WAV"];
	} else {
		[stage generateAround:walter];
		[self checkForStuckedness:dt];
	}
}

- (void)transitionAfterPlayerDeath {
	transitioning = true;

	CCScene *scene;
	if ([HighScores isHighScore:score]) {
		scene = [SettingsLayer scene:score];
	} else {
		scene = [HighScoresLayer scene];
	}
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene withColor:ccBLACK]];
}

- (void)addedCharacter:(BadGuy *)badGuy {
	[self addChild:[[BadGuyView alloc] init:badGuy camera:drawOffset batchNode:batchNode]];
}

- (void)checkForStuckedness:(ccTime)d {
	if (walter.location.x == waltersLocation.x && walter.location.y == waltersLocation.y) {
		timeAtCurrentPosition += d;
		if (timeAtCurrentPosition > 1) {
			[self initStage];
		}
	} else {
		waltersLocation = walter.location;
	}
}

#pragma mark Touch methods

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return true;
}

- (void)attack {
	MeleeAttack *attack = [[MeleeAttack alloc] init:walter];
	[simulation addAttack:attack];
	[self addChild:[[MeleeAttackView alloc] init:attack following:drawOffset batchNode:batchNode] z:10];

	[audio playEffect:@"DSPISTOL.WAV"];
}

- (void)jump {
	if ([walter jump] == noJump) return;
	[audio playEffect:@"DSOOF.WAV"];
}

#pragma mark utils

- (CGSize)currentWindowSize {
	return [[CCDirector sharedDirector] winSize];
}

@end