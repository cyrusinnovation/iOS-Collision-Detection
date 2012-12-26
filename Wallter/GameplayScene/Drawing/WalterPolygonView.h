//
// Created by najati on 9/24/12.
//

#import "CCNode.h"
#import "WalterSimulationActor.h"
#import "Camera.h"

@interface WalterPolygonView : CCNode
- (id)init:(WalterSimulationActor *)_guy following:(Camera *)_offset;
@end