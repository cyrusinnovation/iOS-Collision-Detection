//
// Created by najati on 9/24/12.
//

#import "Camera.h"

@interface ActorView : CCNode
- (id)init:(id <BoundedPolygon, SimulationActor>)_model _scale:(CGPoint)_scale sprite:(CCSprite *)_sprite camera:(Camera *)_camera parent:(CCNode *)_parent;
- (id)init:(id <BoundedPolygon, SimulationActor>)_model _scale:(CGPoint)_scale initialFrame:(NSString *)_initialFrame camera:(Camera *)_camera parent:(CCNode *)_parent;

- (void)startAnimation:(CCAnimation *)animation;

- (void)startRepeatingAnimation:(CCAnimation *)animation;

- (void)setFlipX:(BOOL)x;

- (void)playAnimations:(CCAnimation *)firstAnimation andThen:(CCAnimation *)secondAnimation;


@end