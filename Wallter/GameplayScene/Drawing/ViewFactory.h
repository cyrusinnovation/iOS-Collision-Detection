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

@property(nonatomic, strong) CCAnimation *jumpUp;
@property(nonatomic, strong) CCAnimation *jumpDown;
@property(nonatomic, strong) CCSequence *landThenRun;

- init:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode;

- (ActorView *)createMeleeAttackView:(MeleeAttack *)model;
- (ActorView *)createBadGuyView:(BadGuy *)model;
- (ActorView *)createWalterView:(Walter *)model;
- (ActorView *)createPlatformView:(Platform *)model parent:(CCNode *)parent;

@end