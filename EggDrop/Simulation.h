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
@property(nonatomic) BOOL paused;

- (id)init:(Level *)_level;

- (Star *)addStar:(CGPoint)location;

- (void)update:(ccTime)dt;

- (BOOL)isEggDead;

- (void)redropEgg;

- (void)startLevelOver;

- (void)addTrampolineFrom:(CGPoint)start to:(CGPoint)end;

- (void)pause;
- (void)unpause;
@end
