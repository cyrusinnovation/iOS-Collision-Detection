//
// Created by najati on 9/24/12.
//

#import "CCNode.h"
#import "Stage.h"
#import "Walter.h"
#import "Camera.h"

@class Simulation;

@interface StageView : CCNode
- (id)init:(Simulation *)_stage following:(Camera *)_offset;
@end