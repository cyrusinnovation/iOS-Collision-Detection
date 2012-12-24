//
// Created by najati on 9/24/12.
//

#import "CCSpriteFrameCache.h"
#import "CCSpriteBatchNode.h"
#import "CCSprite.h"
#import "CCAnimation.h"
#import "CCActionInterval.h"
#import "ActorView.h"

@implementation ActorView {
	id<BoundedPolygon,SimulationActor> model;

	Camera *camera;
	CCSprite *sprite;
	CCSpriteBatchNode *batchNode;
	CGPoint scale;
}

- (id)init:(id <BoundedPolygon, SimulationActor>)_model _scale:(CGPoint)_scale _initialFrame:(NSString *)_initialFrame camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	self = [super init];
	if (!self) return self;
	[self scheduleUpdate];

	model = _model;
	scale = _scale;
	camera = _camera;
	batchNode = _batchNode;

	sprite = [CCSprite spriteWithSpriteFrameName:_initialFrame];
	[sprite setScaleX:scale.x * camera.scale];
	[sprite setScaleY:scale.y * camera.scale];
	[batchNode addChild:sprite];

	return self;
}

- (void)setFlipX:(BOOL)x {
	[sprite setFlipX:x];
}

- (void)startRepeatingAnimation:(CCAnimation *)animation {
	// TODO would it be possible to stop just the animation action
	[sprite stopAllActions];
	[sprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
}

- (void)startAnimation:(CCAnimation *)animation {
	// TODO would it be possible to stop just the animation action
	[sprite stopAllActions];
	[sprite runAction:[CCAnimate actionWithAnimation:animation]];
}

- (void)playAnimations:(CCAnimation *)firstAnimation andThen:(CCAnimation *)secondAnimation {
	[sprite stopAllActions];
	CCFiniteTimeAction *firstAnimationAction = [CCAnimate actionWithAnimation:firstAnimation];
	CCFiniteTimeAction *secondAnimationAction = [CCAnimate actionWithAnimation:secondAnimation];
	[sprite runAction:[CCSequence actionOne:firstAnimationAction two:secondAnimationAction]];
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