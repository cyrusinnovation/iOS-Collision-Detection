//
// by najati 
// copyright Cyrus Innovation
//

#import "ccTypes.h"
#import "SATResult.h"
#import "BoundedPolygon.h"

@protocol SimulationActor <NSObject>
- (void)collides:(SATResult)result with:(id <BoundedPolygon>)that;
@property(nonatomic, readonly) BOOL expired;
- (void)update:(ccTime)dt;
@end


