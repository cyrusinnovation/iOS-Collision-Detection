//
// Created by najati on 9/24/12.
//

#import "ccTypes.h"

#import "Environment.h"
#import "BoundedPolygon.h"
#import "SimulationActor.h"

@class BadGuy;
@class MeleeAttack;
@class Stage;
@class Walter;

@interface Simulation : NSObject
- (id)initFor:(id <BoundedPolygon, SimulationActor>)_guy in:(id <Environment>)_environment;
- (void)update:(ccTime)dt;

- (void)addAttack:(id<BoundedPolygon, SimulationActor>)attack;
- (void)addEnemy:(id<BoundedPolygon, SimulationActor>)enemy;
@end