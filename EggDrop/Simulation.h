//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import "Egg.h"
#import "Star.h"

#import "SimulationObserver.h"

@interface Simulation : NSObject

@property(nonatomic, retain) NSObject <SimulationObserver> *observer;

- (id)initWith:(Egg *)_egg;

- (Star *)addStarAt:(float)x and:(float)y;

- (void)update:(ccTime)dt;

- (void)reset;
@end