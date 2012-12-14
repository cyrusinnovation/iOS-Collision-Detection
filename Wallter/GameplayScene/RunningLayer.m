//
//  Wallter
//
//  Created by Najati Imam on 9/24/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


#import "RunningLayer.h"

#import "StageView.h"
#import "WalterPolygonView.h"
#import "Simulation.h"
#import "MeleeAttack.h"
#import "MeleeAttackView.h"
#import "WalterController.h"
#import "SettingsLayer.h"
#import "HighScoresLayer.h"
#import "HighScores.h"
#import "AddBadGuyToStageObserver.h"
#import "BadGuyView.h"
#import "WalterView.h"

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

	WalterController *walterController;
	BOOL transitioning;
	CCSpriteBatchNode *batchNode;
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
	[self addChild:batchNode];

	buffer = 0;
	frameTime = 0.01;
	[self initStage];

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
	walterController = [WalterController from:self attackDelay:frameTime * 3];

	drawOffset = [[Camera alloc] init:walter];

	stage = [[Stage alloc] init];

	simulation = [[Simulation alloc] initFor:walter in:stage];

	AddBadGuyToStageObserver *addBadguyToStageObserver = [[AddBadGuyToStageObserver alloc] init:simulation];
	addBadguyToStageObserver.characterAddedObserver = self;
	stage.platformAddedObserver = addBadguyToStageObserver;

	[stage prime];

	[self addChild:[[StageView alloc] init:stage following:drawOffset]];
//	[self addChild:[[WalterPolygonView alloc] init:walter following:drawOffset]];
	WalterView *walterView = [[WalterView alloc] init:walter camera:drawOffset batchNode:batchNode];
	[self addChild:walterView];

	walter.walterObserver = walterView;

	[self setUpScoreLabel];
}

- (void)setUpScoreLabel {
	scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"font.fnt"];
	CGSize s = [[CCDirector sharedDirector] winSize];
	scoreLabel.position = cgp(s.width / 2, s.height - 30);
	[self addChild:scoreLabel z:100];
}

- (void)update:(ccTime)dt {
	buffer += dt * 0.8;
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

	if (walter.location.y < stage.deathHeight || walter.dead) {
		[self transitionAfterPlayerDeath];
	} else {
		[stage generateAround:walter];
		[self checkForStuckedness:dt];
	}

	[walterController update:dt];
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
	[self addChild:[[BadGuyView alloc] init:badGuy withOffset:drawOffset]];
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

- (void)dealloc {
	[stage release];
	[super dealloc];
}

#pragma mark Touch methods

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	[walterController touchStarted:location];
	return true;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	[walterController touchMoved:location];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	[walterController touchEnded:location];
}

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

#pragma mark controller endpoints

- (void)attack {
	MeleeAttack *attack = [[MeleeAttack alloc] init:walter];
	[simulation addAttack:attack];
	MeleeAttackView *view = [[MeleeAttackView alloc] init:attack following:drawOffset];
	[self addChild:view];
}

- (void)jumpLeft {
	if ([walter jumpLeft] == wallJump) score += 57;
}

- (void)jumpRight {
	if ([walter jumpRight] == wallJump) score += 57;
}

#pragma mark utils

- (CGSize)currentWindowSize {
	return [[CCDirector sharedDirector] winSize];
}

@end