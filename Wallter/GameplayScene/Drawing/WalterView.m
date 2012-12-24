//
// Created by najati on 9/24/12.
//

#import "WalterView.h"
#import "CCSpriteFrameCache.h"
#import "CCSpriteBatchNode.h"
#import "CCSprite.h"
#import "CCAnimation.h"
#import "CCActionInterval.h"
#import "CCActionInstant.h"


static CCAnimation *runningAnimation;
static CCAnimation *jumpUpAnimation;
static CCAnimation *jumpDownAnimation;
static CCAnimation *landAnimation;

@implementation WalterView {
	Walter *model;

	Camera *camera;
	CCSprite *sprite;
	CCSpriteBatchNode *batchNode;

	CGPoint scale;
}

+ (void)initialize {
	float frameDelay = 0.07f;

	runningAnimation = [[CCAnimation alloc] init];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run1.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run2.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run3.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run4.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run5.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run6.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run7.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run0.png"]];
	[runningAnimation setDelayPerUnit:frameDelay];
	[runningAnimation setRestoreOriginalFrame:true];
	[runningAnimation setLoops:INFINITY];

	jumpUpAnimation = [[CCAnimation alloc] init];
	[jumpUpAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump0.png"]];
	[jumpUpAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump1.png"]];
	[jumpUpAnimation setDelayPerUnit:0.1f];
	[jumpUpAnimation setRestoreOriginalFrame:false];

	jumpDownAnimation = [[CCAnimation alloc] init];
	[jumpDownAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump2.png"]];
	[jumpDownAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump3.png"]];
	[jumpDownAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump4.png"]];
	[jumpDownAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump5.png"]];
	[jumpDownAnimation setDelayPerUnit:frameDelay];
	[jumpDownAnimation setRestoreOriginalFrame:false];

	landAnimation = [[CCAnimation alloc] init];
	[landAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump6.png"]];
	[landAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump7.png"]];
	[landAnimation setDelayPerUnit:frameDelay / 2];
	[landAnimation setRestoreOriginalFrame:false];
}

- (id)init:(Walter *)_model camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	self = [super init];
	if (!self) return self;
	[self scheduleUpdate];

	model = _model;
	camera = _camera;
	batchNode = _batchNode;

	scale = cgp(1.25, 1.25);

	sprite = [CCSprite spriteWithSpriteFrameName:@"run0.png"];
	[sprite setScaleX:scale.x * camera.scale];
	[sprite setScaleY:scale.y * camera.scale];
	[batchNode addChild:sprite];

	[self startRepeatingAnimation:runningAnimation];


	return self;
}

- (void)runningLeft {
	[self setFlipX:!model.runningRight];
}

- (void)runningRight {
	[self setFlipX:!model.runningRight];
}

- (void)wallJumping {
	[self startAnimation:jumpUpAnimation];
}

- (void)groundJumping {
	[self startAnimation:jumpUpAnimation];
}

- (void)falling {
	[self startAnimation:jumpDownAnimation];
}

- (void)running {
	[self playAnimations:landAnimation andThen:runningAnimation];
}

- (void)dying {
}

- (void)setFlipX:(BOOL)x {
	[sprite setFlipX:x];
}

- (void)startRepeatingAnimation:(CCAnimation *)animation {
	// TODO would it be possible to stop just the animation action
	[sprite stopAllActions];
	[sprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
}

- (void)startAnimation:(CCAnimation *)animation {
	// TODO would it be possible to stop just the animation action
	[sprite stopAllActions];
	[sprite runAction:[CCAnimate actionWithAnimation:animation]];
}

- (void)playAnimations:(CCAnimation *)firstAnimation andThen:(CCAnimation *)secondAnimation {
	[sprite stopAllActions];
	CCFiniteTimeAction *firstAnimationAction = [CCAnimate actionWithAnimation:firstAnimation];
	CCFiniteTimeAction *secondAnimationAction = [CCAnimate actionWithAnimation:secondAnimation];
	[sprite runAction:[CCSequence actionOne:firstAnimationAction two:secondAnimationAction]];
}

-(void)update:(ccTime) dt {
	if (model.isExpired) {
		[self removeFromParentAndCleanup:true];
	}
}

- (void)draw {
	[camera transform:sprite to:model scale:scale];
	[super draw];
}

- (void)dealloc {
	[batchNode removeChild:sprite cleanup:true];
}

@end