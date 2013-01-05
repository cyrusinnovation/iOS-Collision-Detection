//
// Created by najati on 9/24/12.
//

#import "Camera.h"

@protocol HasFacing;

@interface ActorView : CCNode
@property(nonatomic, readonly) CCSprite *sprite;
@property(nonatomic) CGPoint spriteScale;

- (id)init:(id <BoundedPolygon, SimulationActor, HasFacing>)_model scale:(CGPoint)_scale sprite:(CCSprite *)_sprite camera:(Camera *)_camera parent:(CCNode *)_parent pool:(NSMutableArray *)pool;
- (id)init:(id <BoundedPolygon, SimulationActor, HasFacing>)model scale:(CGPoint)scale animation:(CCAnimation *)animation camera:(Camera *)camera parent:(CCSpriteBatchNode *)parent pool:(NSMutableArray *)pool;

- (void)setModel:(id <BoundedPolygon, SimulationActor, HasFacing>)_model;
- (void)setFlipX:(BOOL)x;

- (void)startAnimation:(CCAnimation *)animation;
- (void)playAnimationSequence:(CCSequence *)animationSequenceAction;

- (void)remove;
- (void)update:(ccTime)dt;

- (void)reinit:(id <BoundedPolygon, SimulationActor, HasFacing>)_model scale:(CGPoint)_scale;


@end