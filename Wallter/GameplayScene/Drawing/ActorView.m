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

- (id)init:(id <BoundedPolygon, SimulationActor>)_model _scale:(CGPoint)_scale initialFrame:(NSString *)_initialFrame camera:(Camera *)_camera parent:(CCNode *)_parent {
	CCSprite *_sprite = [CCSprite spriteWithSpriteFrameName:_initialFrame];
	[_sprite setScaleX:scale.x * camera.scale];
	[_sprite setScaleY:scale.y * camera.scale];

	return [self init:_model scale:_scale sprite:_sprite camera:_camera parent:_parent pool:nil];
}

- (void)setFlipX:(BOOL)x {
	[sprite setFlipX:x];
}

- (void)startRepeatingAnimation:(CCAnimate *)animation {
	// TODO would it be possible to stop just the animation action
	[sprite stopAllActions];
	[sprite runAction:[CCRepeatForever actionWithAction:animation]];
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
	}
}

- (void)remove {
	[pool addObject:self];
	[self removeFromParentAndCleanup:false];
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