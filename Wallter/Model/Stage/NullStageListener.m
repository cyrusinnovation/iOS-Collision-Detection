//
// Created by najati on 9/27/12.
//


#import "NullStageListener.h"
#import "Platform.h"

@implementation NullStageListener
- (void)addedPlatform:(Platform *)platform goingRight:(Boolean)facingRight { }

+ (NSObject <PlatformAddedObserver> *)instance {
	return [[NullStageListener alloc] init];
}

@end