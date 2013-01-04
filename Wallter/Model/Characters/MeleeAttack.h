//
// Created by najati on 9/25/12.
//

#import "BoundedPolygon.h"
#import "SimulationActor.h"
#import "WalterSimulationActorImpl.h"

#define MELEE_ATTACK_WIDTH 70

@interface MeleeAttack : NSObject<BoundedPolygon, SimulationActor, HasFacing>
- (id)init:(id<WalterSimulationActor>)walter;
- (BOOL)expired;
- (void)update:(ccTime)dt;
@end