//
// najati
// copyright cyrus innovation
//

#import "cocos2d.h"
#import "SimulationObserver.h"
#import "ElementOnScreenObserver.h"

#define INTERFACE_LAYER 100

@interface RunningLayer : CCLayerColor<SimulationObserver, ElementOnScreenObserver>
+ (CCScene *)scene;
@end
