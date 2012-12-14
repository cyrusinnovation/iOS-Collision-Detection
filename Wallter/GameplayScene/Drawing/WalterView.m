//
// Created by najati on 9/24/12.
//

#import "WalterView.h"
#import "CCSpriteFrameCache.h"
#import "CCSpriteBatchNode.h"
#import "CCSprite.h"
#import "CCAnimation.h"
#import "CCActionInterval.h"

@implementation WalterView {
	Walter *walter;

	Camera *camera;
	CCSprite *walterSprite;
	CCSpriteBatchNode *batchNode;
}

- (id)init:(Walter *)_guy camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	self = [super init];
	if (!self) return self;

	walter = _guy;
	camera = _camera;

	walterSprite = [CCSprite spriteWithSpriteFrameName:@"run0.png"];
	batchNode = _batchNode;
	[batchNode addChild:walterSprite];

	CCAnimation *runningAnimation = [CCAnimation animation];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run1.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run2.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run3.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run4.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run5.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run6.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run7.png"]];
	[runningAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run0.png"]];
	[runningAnimation setDelayPerUnit:0.1f];
	[runningAnimation setRestoreOriginalFrame:true];

	id runningAnimationAction = [CCAnimate actionWithAnimation:runningAnimation];
	[walterSprite runAction:[CCRepeatForever actionWithAction:runningAnimationAction]];

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

- (void)wallJump {
}

- (void)groundJump {
}

- (void)dealloc {
	[walter release];
	[batchNode removeChild:walterSprite cleanup:true];
	[super dealloc];
}

@end