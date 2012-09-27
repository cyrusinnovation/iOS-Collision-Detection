//
// Created by najati on 9/27/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NullStageListener.h"

@implementation NullStageListener
- (void)addedPlatform:(Platform *)platform { }

+ (NSObject <NewPlatformListener> *)instance {
	return [[NullStageListener alloc] init];
}

@end