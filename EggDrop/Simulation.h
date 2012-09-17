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
@property(nonatomic, retain) Egg *egg;


- (id)initWithInitialEggLocation:(CGPoint)location;

- (Star *)addStarAt:(float)x and:(float)y;

- (void)update:(ccTime)dt;

- (void)resetCurrentArrangement;

- (void)moveEggTo:(CGPoint)point;

- (BOOL)isEggDead;

- (void)resetCurrentStage;

- (void)addTrampolineFrom:(CGPoint)start to:(CGPoint)end;
@end