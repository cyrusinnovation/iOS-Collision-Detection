//
// Created by najati on 9/27/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PlatformAddedObserver.h"

@interface NullStageListener : NSObject<PlatformAddedObserver>
+ (NSObject <PlatformAddedObserver> *)instance;

@end