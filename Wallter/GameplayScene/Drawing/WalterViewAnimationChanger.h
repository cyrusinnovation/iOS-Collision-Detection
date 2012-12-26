//
// Created by najati on 9/24/12.
//

#import "CCNode.h"
#import "WalterSimulationActor.h"
#import "Camera.h"
#import "WalterObserver.h"

@class CCSpriteBatchNode;
@class CCAnimation;
@class ActorView;
@class ViewFactory;

@interface WalterViewAnimationChanger : CCNode <WalterObserver>
- (id)init:(ActorView *)_view factory:(ViewFactory *) _viewFactory;
@end