//
// Created by najati on 9/24/12.
//

#import "CCSpriteFrameCache.h"
#import "CCSpriteBatchNode.h"
#import "CCSprite.h"
#import "CCAnimation.h"
#import "CCActionInterval.h"
#import "BadGuyView.h"
#import "BadGuy.h"

static CCAnimation *walkingAnimation;

@implementation BadGuyView {
	id<BoundedPolygon,SimulationActor> model;

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

+ (CCNode *)createAnimationFor:(BadGuy *)_model camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	BadGuyView *view = [[BadGuyView alloc] init:_model _scale:cgp(1.25, 1.25) _initialFrame:@"walk0.png" camera:_camera batchNode:_batchNode];

	[view startRepeatingAnimation:walkingAnimation];
	[view setFlipX:!_model.facingRight];

	return view;
}

- (id)init:(id <BoundedPolygon, SimulationActor>)_model _scale:(CGPoint)_scale _initialFrame:(NSString *)_initialFrame camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	scale = _scale;

	self = [super init];
	if (!self) return self;
	[self scheduleUpdate];

	model = _model;
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