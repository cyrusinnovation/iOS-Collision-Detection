//
// Created by najati on 9/25/12.
//

#import "MeleeAttack.h"
#import "CCNode.h"
#import "Camera.h"

// TODO should be easily turned into a sprite
@interface MeleeAttackPolygonView : CCNode
- (id)init:(MeleeAttack *)_attack following:(Camera *)_offset;
@end