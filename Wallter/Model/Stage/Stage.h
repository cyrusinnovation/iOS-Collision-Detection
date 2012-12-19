//
// Created by najati on 9/24/12.
//

#import <Foundation/Foundation.h>
#import "Polygon.h"
#import "PlatformAddedObserver.h"
#import "Environment.h"

@class Walter;
@class Platform;

@interface Stage : NSObject<Environment>
@property(nonatomic, retain) NSObject <PlatformAddedObserver> *platformAddedObserver;
@property(nonatomic, readonly) float deathHeight;

- (void)addPlatform:(Platform *)platform;
- (void)generateAround:(Walter *)guy;

- (void)prime;
@end