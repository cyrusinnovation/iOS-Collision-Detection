//
// Created by najati on 9/17/12.
//


@class Star;
@class Trampoline;

@protocol SimulationObserver <NSObject>

- (void)newTrampoline:(Trampoline *)trampoline;

- (void)trampolinesRemoved;

- (void)newStar:(Star *)star;

- (void)starCaught:(Star *)star;

- (void)eggDied;

- (void)eggHitNest;

@end