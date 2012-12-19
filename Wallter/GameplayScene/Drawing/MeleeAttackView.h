//
// Created by najati on 9/24/12.
//

#import "CCNode.h"
#import "Walter.h"
#import "Camera.h"
#import "WalterObserver.h"

@class CCSpriteBatchNode;
@class CCAnimation;
@class BadGuy;
@class MeleeAttack;

@interface MeleeAttackView : CCNode
- (id)init:(MeleeAttack *)_attack following:(Camera *)_offset batchNode:(CCSpriteBatchNode *)_batchNode;
@end