//
// najati
// copyright cyrus innovation
//

#import "cocos2d.h"
#import "ElementOnScreenObserver.h"

#define INTERFACE_LAYER 100

@interface RunningLayer : CCLayerColor<ElementOnScreenObserver>
+ (CCScene *)scene;
@end
