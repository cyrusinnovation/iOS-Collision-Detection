//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import "Egg.h"
#import "Nest.h"
#import "Star.h"

#import "SimulationObserver.h"

@class Level;

@interface Simulation : NSObject

@property(nonatomic, retain) NSObject <SimulationObserver> *observer;

@property(nonatomic, retain) Egg *egg;
@property(nonatomic, retain) Nest *nest;
@property(nonatomic, retain) NSMutableArray *walls;


- (id)init:(Level *)_level;

- (void)redropEgg;
- (void)resetTrampolines;

- (Star *)addStar:(CGPoint)location;
- (void)addTrampolineFrom:(CGPoint)start to:(CGPoint)end;

- (void)update:(ccTime)dt;

- (BOOL)isEggDead;

- (void)pause;
- (void)unpause;
@end
