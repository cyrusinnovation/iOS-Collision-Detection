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
	BadGuy *badGuy;

	Camera *camera;
	CCSprite *badGuySprite;
	CCSpriteBatchNode *batchNode;
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

	badGuy = _badGuy;
	camera = _camera;

	badGuySprite = [CCSprite spriteWithSpriteFrameName:@"walk0.png"];
	[badGuySprite setScale:1.25];

	batchNode = _batchNode;
	[batchNode addChild:badGuySprite];

	[badGuySprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkingAnimation]]];
	[badGuySprite setFlipX:!badGuy.facingRight];

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

-(void)update:(ccTime) dt {
	if (badGuy.dead) {
		[self removeFromParentAndCleanup:true];
	}
}

- (void)dealloc {
	[batchNode removeChild:badGuySprite cleanup:true];
}

@end