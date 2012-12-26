//
// Created by najati on 9/24/12.
//

#import "ccTypes.h"

#import "BoundedPolygon.h"
#import "SimulationActor.h"
#import "SimulationTicker.h"

@interface Simulation : NSObject

- (id)initFor:(id <BoundedPolygon, SimulationActor>)_mainActor;

@property(nonatomic, strong) NSMutableArray *environment;
@property(nonatomic, strong) NSMutableArray *characters;
@property(nonatomic, strong) NSMutableArray *attacks;

- (void)update:(ccTime)dt;

- (void)addAttack:(id <BoundedPolygon, SimulationActor>)attack;
- (void)addEnemy:(id <BoundedPolygon, SimulationActor>)enemy;
- (void)addEnvironmentElement:(id <BoundedPolygon, SimulationActor>)element;
- (void)addTicker:(id <SimulationTicker>)ticker;
@end