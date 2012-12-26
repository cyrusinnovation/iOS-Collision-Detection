//
// by najati 
// copyright Cyrus Innovation
//

#import "ViewFactory.h"

@implementation ViewFactory {
	Camera *camera;
	CCSpriteBatchNode *batchNode;
}
@synthesize fireBallAnimation;
@synthesize walkingAnimation;
@synthesize runningAnimation;
@synthesize jumpUpAnimation;
@synthesize jumpDownAnimation;
@synthesize landAnimation;

- (void)initializeAnimations {
	{
		float frameDelay = 0.008f;

		fireBallAnimation = [[CCAnimation alloc] init];
		for (int i = 1; i <= 38; i += 2) {
			NSString *frameName = [NSString stringWithFormat:@"explosion-%02d.png", i];
			[fireBallAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
		}
		[fireBallAnimation setDelayPerUnit:frameDelay];
		[fireBallAnimation setRestoreOriginalFrame:false];
		[fireBallAnimation setLoops:1];
	}

	{
		float frameDelay = 0.2f;

		walkingAnimation = [[CCAnimation alloc] init];
		[walkingAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk1.png"]];
		[walkingAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk2.png"]];
		[walkingAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk3.png"]];
		[walkingAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk4.png"]];
		[walkingAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk5.png"]];
		[walkingAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk6.png"]];
		[walkingAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk7.png"]];
		[walkingAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk0.png"]];
		[walkingAnimation setDelayPerUnit:frameDelay];
		[walkingAnimation setRestoreOriginalFrame:true];
		[walkingAnimation setLoops:INFINITY];
	}

	{
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
}

- (id)init:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	self = [super init];
	if (!self) return self;

	camera = _camera;
	batchNode = _batchNode;

	[self initializeAnimations];

	return self;
}

- (ActorView *)createMeleeAttackView:(MeleeAttack *)model {
	ActorView *view = [[ActorView alloc] init:model _scale:cgp(2, 0.7) initialFrame:@"explosion-00.png" camera:camera parent:batchNode];
	[view startAnimation:fireBallAnimation];
	return view;
}

- (ActorView *)createBadGuyView:(BadGuy *)model {
	ActorView *view = [[ActorView alloc] init:model _scale:cgp(1.25, 1.25) initialFrame:@"walk0.png" camera:camera parent:batchNode];
	[view startRepeatingAnimation:walkingAnimation];
	[view setFlipX:!model.facingRight];
	return view;
}

- (ActorView *)createWalterView:(WalterSimulationActor *)model {
	ActorView *view = [[ActorView alloc] init:model _scale:cgp(1.25, 1.25) initialFrame:@"run0.png" camera:camera parent:batchNode];
	[view startRepeatingAnimation:walkingAnimation];
	[view setFlipX:!model.runningRight];
	return view;
}

- (ActorView *)createPlatformView:(Platform *)model parent:(CCNode *)parent {
	CCSprite *sprite = [CCSprite spriteWithFile:@"stone.png" rect:(CGRect) {0, 0, model.width, model.height}];

	sprite.anchorPoint = ccp(0, 0);

	[sprite setContentSize:(CGSize) {model.width, model.height}];

	ccTexParams tp = {GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT};
	[sprite.texture setTexParameters:&tp];

	return [[ActorView alloc] init:model _scale:cgp(1, 1) sprite:sprite camera:camera parent:parent];
}

@end