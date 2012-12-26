//
// Created by najati on 9/25/12.
//

#import "BoundedPolygon.h"
#import "SimulationActor.h"
#import "WalterSimulationActor.h"

#define MELEE_ATTACK_WIDTH 70

@interface MeleeAttack : NSObject<BoundedPolygon, SimulationActor>
- (id)init:(WalterSimulationActor *)_walterActor;
- (BOOL)expired;
- (void)update:(ccTime)dt;
@end