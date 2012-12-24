//
// by najati 
// copyright Cyrus Innovation
//

#import "ViewFactory.h"

static CCAnimation *fireBallAnimation;
static CCAnimation *walkingAnimation;

@implementation ViewFactory {
	Camera *camera;
	CCSpriteBatchNode *batchNode;
}

+ (void)initialize {
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
}

- (id)init:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	self = [super init];
	if (!self) return self;

	camera = _camera;
	batchNode = _batchNode;

	return self;
}

- (ActorView *)createMeleeAttackView:(MeleeAttack *)model {
	ActorView *view = [[ActorView alloc] init:model _scale:cgp(2, 0.7) _initialFrame:@"explosion-00.png" camera:camera batchNode:batchNode];
	[view startAnimation:fireBallAnimation];
	return view;
}

- (ActorView *)createBadGuyView:(BadGuy *)model {
	ActorView *view = [[ActorView alloc] init:model _scale:cgp(1.25, 1.25) _initialFrame:@"walk0.png" camera:camera batchNode:batchNode];
	[view startRepeatingAnimation:walkingAnimation];
	[view setFlipX:!model.facingRight];
	return view;
}

@end