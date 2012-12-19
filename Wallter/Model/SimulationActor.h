//
// by najati 
// copyright Cyrus Innovation
//

#import "SATResult.h"

@protocol SimulationActor <NSObject>
- (void)collides:(SATResult)result with:(id <BoundedPolygon>)that;
@property(nonatomic, readonly) Boolean isExpired;
@end