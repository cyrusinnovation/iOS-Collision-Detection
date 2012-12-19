//
// Created by najati on 9/17/12.
//


#import "NullSimulationObserver.h"
#import "Star.h"
#import "Trampoline.h"

@implementation NullSimulationObserver
- (void)newTrampoline:(Trampoline *)trampoline { }
- (void)trampolinesRemoved { }
- (void)newStar:(Star *)star { }
- (void)starCaught:(Star *)star { }
- (void)eggDied { }
- (void)eggHitNest { }
@end