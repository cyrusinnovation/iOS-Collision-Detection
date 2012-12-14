//
// Created by najati on 9/24/12.
//

#import "Walter.h"
#import "Stage.h"
#import "BadGuy.h"
#import "ccTypes.h"

@class MeleeAttack;

@interface Simulation : NSObject

@property(nonatomic, retain) Walter *guy;
@property(nonatomic, retain) Stage *stage;

- (id)initFor:(Walter *)_guy in:(Stage *)_stage;

- (void)update:(ccTime)dt;

- (void)addAttack:(MeleeAttack *)_attack;

- (void)addBadGuy:(BadGuy *)guy;
@end