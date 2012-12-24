//
// by najati 
// copyright Cyrus Innovation
//

#import "cocos2d.h"

@class MeleeAttack;
@class Camera;

@interface ViewFactory : NSObject
- init:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode;
- (CCNode *)createViewFor:(MeleeAttack *)_model;
@end