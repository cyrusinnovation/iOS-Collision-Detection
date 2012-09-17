//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NullSimulationObserver.h"
#import "Star.h"
#import "Trampoline.h"


@implementation NullSimulationObserver
- (void)newTrampoline:(Trampoline *)trampoline { }
- (void)newStar:(Star *)star { }
- (void)starCaught:(Star *)star { }
@end