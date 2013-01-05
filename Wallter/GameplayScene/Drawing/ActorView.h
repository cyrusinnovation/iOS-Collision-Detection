//
// Created by najati on 9/24/12.
//

#import "Camera.h"

@protocol HasFacing;

@interface ActorView : CCNode
@property(nonatomic, readonly) CCSprite *sprite;
@property(nonatomic) CGPoint spriteScale;

- (id)init:(id <BoundedPolygon, SimulationActor, HasFacing>)model scale:(CGPoint)scale sprite:(CCSprite *)sprite camera:(Camera *)camera parent:(CCNode *)parent pool:(NSMutableArray *)pool;
- (id)init:(id <BoundedPolygon, SimulationActor, HasFacing>)model scale:(CGPoint)scale animation:(CCAnimation *)animation camera:(Camera *)camera parent:(CCSpriteBatchNode *)parent pool:(NSMutableArray *)pool;

- (void)setModel:(id <BoundedPolygon, SimulationActor, HasFacing>)_model;

- (id)init:(id <BoundedPolygon, SimulationActor, HasFacing>)_model scale:(CGPoint)_scale spriteFileName:(NSString *)name camera:(Camera *)camera parent:(CCNode *)_parent pool:(NSMutableArray *)pool;

- (void)startAnimation:(CCAnimation *)animation;
- (void)playAnimationSequence:(CCSequence *)animationSequenceAction;

- (void)remove;
- (void)update:(ccTime)dt;


@end