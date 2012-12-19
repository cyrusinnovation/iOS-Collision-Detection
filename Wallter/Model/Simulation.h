//
// Created by najati on 9/24/12.
//

#import "ccTypes.h"

#import "Environment.h"
#import "BoundedPolygon.h"
#import "SimulationActor.h"

@interface Simulation : NSObject
- (id)initFor:(id <BoundedPolygon, SimulationActor>)_mainActor in:(id <Environment>)_environment;
- (void)update:(ccTime)dt;

- (void)addAttack:(id<BoundedPolygon, SimulationActor>)attack;
- (void)addEnemy:(id<BoundedPolygon, SimulationActor>)enemy;
@end