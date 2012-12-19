//
// Created by najati on 9/24/12.
//

#import "CCSpriteFrameCache.h"
#import "CCSpriteBatchNode.h"
#import "CCSprite.h"
#import "CCAnimation.h"
#import "CCActionInterval.h"
#import "BadGuy.h"
#import "EnemyView.h"

@implementation EnemyView {
	BadGuy *badGuy;

	Camera *camera;
	CCSprite *badGuySprite;
	CCSpriteBatchNode *batchNode;

	CCAnimation *walkingAnimation;
}

- (id)init:(BadGuy *)_badGuy camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	self = [super init];
	if (!self) return self;

	badGuy = _badGuy;
	camera = _camera;

	badGuySprite = [CCSprite spriteWithSpriteFrameName:@"walk0.png"];
	[badGuySprite setScale:1.25];
	batchNode = _batchNode;
	[batchNode addChild:badGuySprite z:10];

	float frameDelay = 0.13f;

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

	[badGuySprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkingAnimation]]];

	return self;
}

- (void)draw {
	CGPoint delta = [camera getOffset];

	CGPoint position = cgp_add(cgp(badGuy.left, badGuy.bottom), delta);
	position.x += (badGuySprite.boundingBox.size.width) / 2;
	position.y += badGuySprite.boundingBox.size.height / 2;
	[badGuySprite setPosition:position];

	[super draw];
}

- (void)dealloc {
	[batchNode removeChild:badGuySprite cleanup:true];
}

@end