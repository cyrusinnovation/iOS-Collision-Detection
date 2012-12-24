//
// Created by najati on 9/24/12.
//

#import "ccTypes.h"

#import "BoundedPolygon.h"
#import "SimulationActor.h"
#import "SimulationTicker.h"

@protocol SimulationObserver;

@interface Simulation : NSObject

- (id)initFor:(id <BoundedPolygon, SimulationActor>)_mainActor;

@property(nonatomic, retain) NSObject <SimulationObserver> *simulationObserver;
@property(nonatomic, strong) NSMutableArray *environment;

- (void)update:(ccTime)dt;

- (void)addAttack:(id <BoundedPolygon, SimulationActor>)attack;
- (void)addEnemy:(id <BoundedPolygon, SimulationActor>)enemy;
- (void)addEnvironmentElement:(id <BoundedPolygon, SimulationActor>)element;
- (void)addTicker:(id <SimulationTicker>)ticker;
@end