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

@implementation WalterView {
	Walter *walter;

	Camera *camera;
	CCSprite *walterSprite;
	CCSpriteBatchNode *batchNode;

	CCAnimation *runningAnimation;
	CCAnimation *jumpUpAnimation;
	CCAnimation *jumpDownAnimation;
	CCAnimation *landAnimation;
}

- (id)init:(Walter *)_guy camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	self = [super init];
	if (!self) return self;

	walter = _guy;
	camera = _camera;

	walterSprite = [CCSprite spriteWithSpriteFrameName:@"run0.png"];
	[walterSprite setScale:1.25];
	batchNode = _batchNode;
	[batchNode addChild:walterSprite];

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
	[landAnimation setDelayPerUnit:frameDelay/2];
	[landAnimation setRestoreOriginalFrame:false];

	[walterSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:runningAnimation]]];

	return self;
}

- (void)draw {
	CGPoint delta = [camera getOffset];

	CGPoint position = cgp_add(walter.location, delta);
	position.x += walter.width / 2;
	position.y += walterSprite.boundingBox.size.height / 2;
	[walterSprite setPosition:position];

	[super draw];
}

- (void)runningLeft {
	[walterSprite setFlipX:!walter.runningRight];
}

- (void)runningRight {
	[walterSprite setFlipX:!walter.runningRight];
}

- (void)wallJumping {
	[walterSprite stopAllActions];
	[walterSprite runAction:[CCAnimate actionWithAnimation:jumpUpAnimation]];
}

- (void)groundJumping {
	[self wallJumping];
}

- (void)falling {
	[walterSprite stopAllActions];
	[walterSprite runAction:[CCAnimate actionWithAnimation:jumpDownAnimation]];
}

- (void)running {
	[walterSprite stopAllActions];
	CCFiniteTimeAction* landAnimationAction = [CCAnimate actionWithAnimation:landAnimation];
	CCFiniteTimeAction* runAnimationAction = [CCAnimate actionWithAnimation:runningAnimation];
	[walterSprite runAction:[CCSequence actionOne:landAnimationAction two:runAnimationAction]];
}

- (void)dealloc {
	[batchNode removeChild:walterSprite cleanup:true];
}

@end