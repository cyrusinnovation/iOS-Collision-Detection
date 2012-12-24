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
	MeleeAttack *model;

	CCSpriteBatchNode *batchNode;
	CCSprite *sprite;

	Camera *camera;
	CGPoint scale;
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

	scale = cgp(2, 0.7);

	model = _attack;
	camera = _offset;

	sprite = [CCSprite spriteWithSpriteFrameName:@"explosion-00.png"];

	batchNode = _batchNode;
	[batchNode addChild:sprite];

	[sprite runAction:[CCAnimate actionWithAnimation:fireBallAnimation]];

	return self;
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