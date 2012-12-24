//
// Created by najati on 9/24/12.
//

#import "CCSpriteFrameCache.h"
#import "CCSpriteBatchNode.h"
#import "CCSprite.h"
#import "CCAnimation.h"
#import "CCActionInterval.h"
#import "BadGuy.h"
#import "BadGuyView.h"
#import "MeleeAttackView.h"
#import "MeleeAttack.h"

static CCAnimation *fireBallAnimation;

@implementation MeleeAttackView {
	MeleeAttack *meleeAttack;

	CCSpriteBatchNode *batchNode;
	CCSprite *attackSprite;

	Camera *camera;
}

+ (void) initialize {
	float frameDelay = 0.008f;

	fireBallAnimation = [[CCAnimation alloc] init];
	for (int i = 1; i <= 38; i+=2) {
		NSString *frameName = [NSString stringWithFormat:@"explosion-%02d.png", i];
		[fireBallAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
	}
	[fireBallAnimation setDelayPerUnit:frameDelay];
	[fireBallAnimation setRestoreOriginalFrame:false];
	[fireBallAnimation setLoops:1];
}

- (id)init:(MeleeAttack *)_attack following:(Camera *) _offset batchNode:(CCSpriteBatchNode *)_batchNode {
	self = [super init];
	if (!self) return self;

	[self scheduleUpdate];

	meleeAttack = _attack;
	camera = _offset;

	attackSprite = [CCSprite spriteWithSpriteFrameName:@"explosion-00.png"];
	[attackSprite setScaleX:2 * camera.scale];
	[attackSprite setScaleY:0.7 * camera.scale];

	batchNode = _batchNode;
	[batchNode addChild:attackSprite];

	[attackSprite runAction:[CCAnimate actionWithAnimation:fireBallAnimation]];

	return self;
}

- (void)draw {
	[camera transform:attackSprite to:meleeAttack];
	[super draw];
}

-(void)update:(ccTime) dt {
	if (meleeAttack.isExpired) {
		[self removeFromParentAndCleanup:true];
	}
}

- (void)dealloc {
	[batchNode removeChild:attackSprite cleanup:true];
}

@end