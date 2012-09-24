//
// Created by najati on 9/24/12.
//

#import "CCNode.h"
#import "Stage.h"
#import "Guy.h"

@interface StageView : CCNode
- (id)init:(Stage *)_stage following:(Guy *)_guy;
@end