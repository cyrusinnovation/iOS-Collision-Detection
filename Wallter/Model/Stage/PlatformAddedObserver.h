//
// Created by najati on 9/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Polygon.h"

@class Platform;

@protocol PlatformAddedObserver

- (void)addedPlatform:(Platform *)platform goingRight:(Boolean)facingRight;

@end