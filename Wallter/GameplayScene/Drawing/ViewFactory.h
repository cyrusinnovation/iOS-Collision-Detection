//
// by najati 
// copyright Cyrus Innovation
//

#import "cocos2d.h"

#import "Camera.h"
#import "ActorView.h"
#import "MeleeAttack.h"
#import "BadGuy.h"

@interface ViewFactory : NSObject
- init:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode;
- (ActorView *)createMeleeAttackView:(MeleeAttack *)model;
- (ActorView *)createBadGuyView:(BadGuy *)model;
@end