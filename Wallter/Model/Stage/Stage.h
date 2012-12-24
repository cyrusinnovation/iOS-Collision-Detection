//
// Created by najati on 9/24/12.
//

#import <Foundation/Foundation.h>
#import "Polygon.h"
#import "PlatformAddedObserver.h"

@class Walter;
@class Platform;
@class Simulation;

@interface Stage : NSObject
@property(nonatomic, retain) NSObject <PlatformAddedObserver> *platformAddedObserver;
@property(nonatomic, readonly) float deathHeight;

- (id)init:(Simulation *)_simulation;

- (void)addPlatform:(Platform *)platform;
- (void)generateAround:(Walter *)guy;

- (void)prime;
@end