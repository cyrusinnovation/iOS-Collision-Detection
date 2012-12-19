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

@property(nonatomic, retain) Stage *stage;

- (id)initFor:(Walter *)_guy in:(Stage *)_stage;

- (void)update:(ccTime)dt;

- (void)addAttack:(id<BoundedPolygon, SimulationActor>)_attack;
- (void)addEnemy:(id<BoundedPolygon, SimulationActor>)enemy;
@end