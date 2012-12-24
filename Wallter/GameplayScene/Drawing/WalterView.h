//
// Created by najati on 9/24/12.
//

#import "CCNode.h"
#import "Walter.h"
#import "Camera.h"
#import "WalterObserver.h"

@class CCSpriteBatchNode;
@class CCAnimation;

@interface WalterView : CCNode <WalterObserver>
- (id)init:(Walter *)_model camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode;
@end