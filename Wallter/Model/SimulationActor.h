//
// by najati 
// copyright Cyrus Innovation
//

#import "SATResult.h"
#import "ccTypes.h"

@protocol SimulationActor <NSObject>
- (void)collides:(SATResult)result with:(id <BoundedPolygon>)that;
@property(nonatomic, readonly) Boolean isExpired;
- (void)update:(ccTime)dt;

@end