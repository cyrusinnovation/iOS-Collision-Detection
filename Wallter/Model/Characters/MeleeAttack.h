//
// Created by najati on 9/25/12.
//

#import "Walter.h"
#import "Polygon.h"

@interface MeleeAttack : NSObject<BoundedPolygon, SimulationActor>
- (id)init:(Walter *)_guy;
- (void)update:(ccTime)dt;
@end