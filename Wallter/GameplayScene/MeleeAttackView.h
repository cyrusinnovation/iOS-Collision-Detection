//
// Created by najati on 9/25/12.
//

#import "MeleeAttack.h"
#import "CCNode.h"
#import "DrawOffset.h"

// TODO should be easily turned into a sprite
@interface MeleeAttackView : CCNode
- (id)init:(MeleeAttack *)_attack following:(DrawOffset *)_offset;
@end