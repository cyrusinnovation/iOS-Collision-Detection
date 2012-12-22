//
// Created by najati on 9/24/12.
//

#import "ccTypes.h"

#import "Environment.h"
#import "BoundedPolygon.h"
#import "SimulationActor.h"

@protocol SimulationObserver;

@interface Simulation : NSObject
- (id)initFor:(id <BoundedPolygon, SimulationActor>)_mainActor in:(id <Environment>)_environment;
@property (nonatomic, retain) NSObject <SimulationObserver> *simulationObserver;

- (void)update:(ccTime)dt;

- (void)addAttack:(id<BoundedPolygon, SimulationActor>)attack;
- (void)addEnemy:(id<BoundedPolygon, SimulationActor>)enemy;
@end