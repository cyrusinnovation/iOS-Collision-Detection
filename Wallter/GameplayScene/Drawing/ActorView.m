//
// Created by najati on 9/24/12.
//

#import "CCSpriteFrameCache.h"
#import "CCSpriteBatchNode.h"
#import "CCSprite.h"
#import "CCAnimation.h"
#import "CCActionInterval.h"
#import "ActorView.h"
#import "HasFacing.h"

@implementation ActorView {
	id <BoundedPolygon, SimulationActor> model;

	Camera *camera;
	CCSprite *sprite;
	CCNode *parent;
	CGPoint scale;
	NSMutableArray *pool;
}

@synthesize sprite;

- (id)init:(id <BoundedPolygon, SimulationActor>)_model scale:(CGPoint)_scale sprite:(CCSprite *)_sprite camera:(Camera *)_camera parent:(CCNode *)_parent pool:(NSMutableArray *)_pool {
	self = [super init];
	if (!self) return self;
	[self scheduleUpdate];

	model = _model;
	scale = _scale;
	camera = _camera;
	parent = _parent;

	sprite = _sprite;

	pool = _pool;

	[camera transform:sprite to:model scale:scale];
	[parent addChild:sprite];

	return self;
}

- (id)init:(id <BoundedPolygon, SimulationActor>)_model scale:(CGPoint)_scale initialFrame:(NSString *)initialFrame camera:(Camera *)_camera parent:(CCNode *)_parent pool:(NSMutableArray *)_pool {
	CCSprite *_sprite = [CCSprite spriteWithSpriteFrameName:initialFrame];
	[_sprite setScaleX:scale.x * _camera.scale];
	[_sprite setScaleY:scale.y * _camera.scale];

	return [self init:_model scale:_scale sprite:_sprite camera:_camera parent:_parent pool:_pool];
}

- (id)init:(id <BoundedPolygon, SimulationActor, HasFacing>)_model scale:(CGPoint)_scale animation:(CCAnimation *)_animation camera:(Camera *)_camera parent:(CCSpriteBatchNode *)_parent pool:(NSMutableArray *)_pool {
	CCSpriteFrame *spriteFrame = [(CCAnimationFrame *) [_animation.frames objectAtIndex:0] spriteFrame];
	CCSprite *_sprite = [CCSprite spriteWithTexture:spriteFrame.texture rect:spriteFrame.rect];
	ActorView *view = [self init:_model scale:_scale sprite:_sprite camera:_camera parent:_parent pool:_pool];
	// TODO would it be possible to stop just the animation action
	[view startAnimation:[CCAnimate actionWithAnimation:_animation]];
	[view setFlipX:!_model.facingRight];
	return view;
}

- (void)setFlipX:(BOOL)x {
	[sprite setFlipX:x];
}

- (void)startAnimation:(CCAnimate *)animation {
	// TODO would it be possible to stop just the animation action
	[sprite stopAllActions];
	[sprite runAction:animation];
}

- (void)playAnimationSequence:(CCSequence *)animationSequenceAction {
	[sprite stopAllActions];
	[sprite runAction:animationSequenceAction];
}

- (void)setModel:(id <BoundedPolygon, SimulationActor>)_model {
	model = _model;

	float width = model.right - model.left;
	float height = model.top - model.bottom;

	[sprite setTextureRect:(CGRect) {0, 0, (width), (height)}];
	sprite.anchorPoint = ccp(0, 0);
	[sprite setContentSize:(CGSize) {(width), (height)}];
}

- (void)update:(ccTime)dt {
	if (model.expired) {
		[self remove];
	} else {
		[camera transform:sprite to:model scale:scale];
	}
}

- (void)remove {
	[pool addObject:self];
	[self removeFromParentAndCleanup:false];
	[sprite removeFromParentAndCleanup:true];
}

- (void)dealloc {
	[self remove];
}

@end