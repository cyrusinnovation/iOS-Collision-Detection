//
// Created by najati on 12/14/12.
//

#import <Foundation/Foundation.h>

@class BadGuy;
@class MeleeAttack;

@protocol SimulationObserver
-(void)addedCharacter:(BadGuy*) badGuy;
-(void)addedAttack:(MeleeAttack*) attack;
@end