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
	id <BoundedPolygon, SimulationActor, HasFacing> model;

	Camera *camera;
	CCSprite *sprite;
	CCNode *parent;
	NSMutableArray *pool;
	CCAnimate *animation;
}

@synthesize sprite;
@synthesize spriteScale;

- (id)init:(id <BoundedPolygon, SimulationActor, HasFacing>)_model scale:(CGPoint)_scale sprite:(CCSprite *)_sprite camera:(Camera *)_camera parent:(CCNode *)_parent pool:(NSMutableArray *)_pool {
	self = [super init];
	if (!self) return self;
	[self scheduleUpdate];

	model = _model;
	spriteScale = _scale;
	camera = _camera;
	parent = _parent;

	sprite = _sprite;

	pool = _pool;

	[camera transform:sprite to:model scale:spriteScale];
	[parent addChild:sprite];

	return self;
}

- (void)reinit:(id <BoundedPolygon, SimulationActor, HasFacing>)_model scale:(CGPoint)_scale {
	[self setModel:_model];

	spriteScale = _scale;

	[self update:0];
}

- (id)init:(id <BoundedPolygon, SimulationActor, HasFacing>)_model scale:(CGPoint)_scale animation:(CCAnimation *)_animation camera:(Camera *)_camera parent:(CCSpriteBatchNode *)_parent pool:(NSMutableArray *)_pool {
	CCSpriteFrame *spriteFrame = [(CCAnimationFrame *) [_animation.frames objectAtIndex:0] spriteFrame];
	CCSprite *_sprite = [CCSprite spriteWithTexture:spriteFrame.texture rect:spriteFrame.rect];

	self = [self init:_model scale:_scale sprite:_sprite camera:_camera parent:_parent pool:_pool];
	if (self) {
		[self startAnimation:_animation];
	}

	[self update:0];
	return self;
}

- (void)setFlipX:(BOOL)x {
	[sprite setFlipX:x];
}

- (void)startAnimation:(CCAnimation *)_animation {
	if (!animation) {
		animation = [CCAnimate actionWithAnimation:_animation];
	} else {
		[animation reinit:_animation];
	}
	[sprite stopAllActions];
	[sprite runAction:animation];
}

- (void)playAnimationSequence:(CCSequence *)animationSequenceAction {
	[sprite stopAllActions];
	[sprite runAction:animationSequenceAction];
}

- (void)setModel:(id <BoundedPolygon, SimulationActor, HasFacing>)_model {
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
		[sprite setFlipX:!model.facingRight];
		[camera transform:sprite to:model scale:spriteScale];
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