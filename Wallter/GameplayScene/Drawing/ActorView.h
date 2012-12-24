//
// Created by najati on 9/24/12.
//

#import "Camera.h"

@interface ActorView : CCNode
- (id)init:(id <BoundedPolygon, SimulationActor>)_model _scale:(CGPoint)_scale _initialFrame:(NSString *)_initialFrame camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode;

- (void)startAnimation:(CCAnimation *)animation;

@end