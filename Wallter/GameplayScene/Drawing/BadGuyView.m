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

static CCAnimation *walkingAnimation;

@implementation BadGuyView {
	BadGuy *model;

	Camera *camera;
	CCSprite *sprite;
	CCSpriteBatchNode *batchNode;
	CGPoint scale;
}

+ (void) initialize {
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

- (id)init:(BadGuy *)_badGuy camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	self = [super init];
	if (!self) return self;

	[self scheduleUpdate];

	scale = cgp(1.25, 1.25);

	model = _badGuy;
	camera = _camera;

	sprite = [CCSprite spriteWithSpriteFrameName:@"walk0.png"];
	[sprite setScale:1.25 * camera.scale];

	batchNode = _batchNode;
	[batchNode addChild:sprite];

	[sprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkingAnimation]]];
	[sprite setFlipX:!model.facingRight];

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