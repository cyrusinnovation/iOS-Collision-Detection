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

	Camera *camera;
	CCSprite *attackSprite;
	CCSpriteBatchNode *batchNode;
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
	[attackSprite setScaleX:2];
	[attackSprite setScaleY:0.7];

	batchNode = _batchNode;
	[batchNode addChild:attackSprite z:10];

	[attackSprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:fireBallAnimation]]];

	return self;
}

- (void)draw {
	CGPoint delta = [camera getOffset];

	CGPoint position = cgp_add(cgp(meleeAttack.left, meleeAttack.bottom), delta);
	position.x += 70 / 2;
	position.y += 30 / 2;
	[attackSprite setPosition:position];

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