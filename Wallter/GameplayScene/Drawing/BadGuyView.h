//
// Created by najati on 9/24/12.
//

#import "Camera.h"

@class BadGuy;

@interface BadGuyView : CCNode
- (id)init:(id <BoundedPolygon, SimulationActor>)_model _scale:(CGPoint)_scale _initialFrame:(NSString *)_initialFrame camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode;
+ (CCNode *)createAnimationFor:(BadGuy *)_model camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode;
@end