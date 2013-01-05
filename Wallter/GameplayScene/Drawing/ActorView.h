//
// Created by najati on 9/24/12.
//

#import "Camera.h"

@protocol HasFacing;

@interface ActorView : CCNode
@property(nonatomic, readonly) CCSprite *sprite;
@property(nonatomic) CGPoint spriteScale;


- (id)init:(id <BoundedPolygon, SimulationActor>)_model scale:(CGPoint)_scale sprite:(CCSprite *)_sprite camera:(Camera *)_camera parent:(CCNode *)_parent pool:(NSMutableArray *)pool;

- (void)startAnimation:(CCAnimation *)animation;

- (id)init:(id <BoundedPolygon, SimulationActor, HasFacing>)model scale:(CGPoint)scale animation:(CCAnimation *)animation camera:(Camera *)camera parent:(CCSpriteBatchNode *)parent pool:(NSMutableArray *)pool;

- (void)setFlipX:(BOOL)x;

- (void)playAnimationSequence:(CCSequence *)animationSequenceAction;

- (void)setModel:(id <BoundedPolygon, SimulationActor>)_model;

- (void)remove;

- (void)update:(ccTime)dt;


@end