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
	CCNode *parent;
	CGPoint scale;
}

- (id)init:(id <BoundedPolygon, SimulationActor>)_model _scale:(CGPoint)_scale sprite:(CCSprite *)_sprite camera:(Camera *)_camera parent:(CCNode *)_parent {
	self = [super init];
	if (!self) return self;
	[self scheduleUpdate];

	model = _model;
	scale = _scale;
	camera = _camera;
	parent = _parent;

	sprite = _sprite;

	[camera transform:sprite to:model scale:scale];
	[parent addChild:sprite];

	return self;
}

- (id)init:(id <BoundedPolygon, SimulationActor>)_model _scale:(CGPoint)_scale initialFrame:(NSString *)_initialFrame camera:(Camera *)_camera parent:(CCNode *)_parent {
	CCSprite *_sprite = [CCSprite spriteWithSpriteFrameName:_initialFrame];
	[_sprite setScaleX:scale.x * camera.scale];
	[_sprite setScaleY:scale.y * camera.scale];

	return [self init:_model _scale:_scale sprite:_sprite camera:_camera parent:_parent];
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
	if (model.expired) {
		[self remove];
	}
}

- (void)remove {
	[self removeFromParentAndCleanup:true];
	[sprite removeFromParentAndCleanup:true];
}

- (void)draw {
	[camera transform:sprite to:model scale:scale];
	[super draw];
}

- (void)dealloc {
	[self remove];
}


@end