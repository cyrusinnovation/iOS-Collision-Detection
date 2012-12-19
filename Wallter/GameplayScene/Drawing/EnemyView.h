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

@interface EnemyView : CCNode
- (id)init:(BadGuy *)_guy camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode;
@end