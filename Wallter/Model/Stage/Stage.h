//
// Created by najati on 9/24/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import "Polygon.h"
#import "NewPlatformListener.h"

@class Guy;
@class Platform;

@interface Stage : NSObject
@property(nonatomic, retain) NSMutableArray *walls;
@property(nonatomic, retain) NSObject <NewPlatformListener> *listener;
@property(nonatomic, readonly) float death_height;


- (void)addPlatform:(Platform *)platform;
- (void)generateAround:(Guy *)guy;

- (void)prime;
@end