//
// Created by najati on 9/24/12.
//

#import <Foundation/Foundation.h>
#import "Polygon.h"
#import "PlatformAddedObserver.h"

@class Walter;
@class Platform;

@interface Stage : NSObject
@property(nonatomic, retain) NSMutableArray *walls;
@property(nonatomic, retain) NSObject <PlatformAddedObserver> *platformAddedObserver;
@property(nonatomic, readonly) float deathHeight;


- (void)addPlatform:(Platform *)platform;
- (void)generateAround:(Walter *)guy;

- (void)prime;
@end