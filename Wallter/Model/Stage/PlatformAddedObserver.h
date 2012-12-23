//
// Created by najati on 9/25/12.
//


#import "Polygon.h"

@class Platform;

@protocol PlatformAddedObserver

- (void)addedPlatform:(Platform *)platform goingRight:(BOOL)facingRight;

@end