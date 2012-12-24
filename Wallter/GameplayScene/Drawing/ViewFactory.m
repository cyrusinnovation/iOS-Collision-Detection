//
// by najati 
// copyright Cyrus Innovation
//

#import "ViewFactory.h"
#import "Camera.h"
#import "MeleeAttack.h"
#import "ActorView.h"

static CCAnimation *fireBallAnimation;

@implementation ViewFactory {
	Camera *camera;
	CCSpriteBatchNode *batchNode;
}

+ (void)initialize {
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

- (id)init:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	self = [super init];
	if (!self) return self;

	camera = _camera;
	batchNode = _batchNode;
	
	return self;
}

- (CCNode *)createViewFor:(MeleeAttack *)_model {
	ActorView *view = [[ActorView alloc] init:_model _scale:cgp(2, 0.7) _initialFrame:@"explosion-00.png" camera:camera batchNode:batchNode];
	[view startAnimation:fireBallAnimation];
	return view;
}


@end