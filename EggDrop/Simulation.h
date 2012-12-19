//
// Created by najati on 9/17/12.
//


#import <Foundation/Foundation.h>

#import "Egg.h"
#import "Nest.h"
#import "Star.h"

#import "SimulationObserver.h"
#import "Polygon.h"
#import "Fan.h"

@class Level;

@interface Simulation : NSObject

@property(nonatomic, retain) NSObject <SimulationObserver> *observer;

@property(nonatomic, retain) Egg *egg;
@property(nonatomic, retain) Nest *nest;
@property(nonatomic, retain) NSMutableArray *walls;
@property(nonatomic, retain) id fans;

- (id)init:(Level *)_level;

- (void)redropEgg;
- (void)resetTrampolines;

- (Star *)addStar:(CGPoint)location;
- (void)addTrampolineFrom:(CGPoint)start to:(CGPoint)end;
- (void)addFan:(Fan *)polygon;

- (void)update:(ccTime)dt;

- (BOOL)isEggDead;

- (void)pause;
- (void)unpause;

@end
