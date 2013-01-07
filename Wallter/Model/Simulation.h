//
// Created by najati on 9/24/12.
//

#import "ccTypes.h"

#import "BoundedPolygon.h"
#import "SimulationActor.h"
#import "SimulationTicker.h"

@interface Simulation : NSObject

- (id)init;

@property(nonatomic, strong) NSMutableArray *environment;
@property(nonatomic, strong) NSMutableArray *characters;
@property(nonatomic, strong) NSMutableArray *actors;

- (void)update:(ccTime)dt;

- (void)addActor:(id <BoundedPolygon, SimulationActor>)actor;
- (void)addEnemy:(id <BoundedPolygon, SimulationActor>)enemy;
- (void)addEnvironmentElement:(id <BoundedPolygon, SimulationActor>)element;
- (void)addTicker:(id <SimulationTicker>)ticker;
@end