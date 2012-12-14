//
// Created by najati on 9/24/12.
//

#import "CCNode.h"
#import "Walter.h"
#import "Camera.h"
#import "WalterObserver.h"

@class CCSpriteBatchNode;

@interface WalterView : CCNode <WalterObserver>
- (id)init:(Walter *)_guy camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode;
@end