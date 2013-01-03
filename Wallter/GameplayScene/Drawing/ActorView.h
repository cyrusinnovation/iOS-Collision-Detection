//
// Created by najati on 9/24/12.
//

#import "Camera.h"

@interface ActorView : CCNode
@property(nonatomic, readonly, strong) CCSprite *sprite;

- (id)init:(id <BoundedPolygon, SimulationActor>)_model scale:(CGPoint)_scale sprite:(CCSprite *)_sprite camera:(Camera *)_camera parent:(CCNode *)_parent pool:(NSMutableArray *)pool;

- (id)init:(id <BoundedPolygon, SimulationActor>)_model _scale:(CGPoint)_scale initialFrame:(NSString *)initialFrame camera:(Camera *)camera parent:(CCNode *)parent pool:(NSMutableArray *)pool;

- (void)startAnimation:(CCAnimate *)animation;

- (void)startRepeatingAnimation:(CCAnimate *)animation;

- (void)setFlipX:(BOOL)x;

- (void)playAnimationSequence:(CCSequence *)animationSequenceAction;

- (void)setModel:(id <BoundedPolygon, SimulationActor>)_model;

- (void)remove;

- (void)update:(ccTime)dt;


@end