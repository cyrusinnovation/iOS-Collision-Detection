//
// Created by najati on 9/25/12.
//


#import "Platform.h"

@protocol PlatformAddedObserver

- (void)addedPlatform:(Platform *)platform goingRight:(BOOL)facingRight;

@end