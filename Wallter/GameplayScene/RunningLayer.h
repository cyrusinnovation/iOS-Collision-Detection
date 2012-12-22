//
// najati
// copyright cyrus innovation
//

#import "cocos2d.h"
#import "SimulationObserver.h"

#define INTERFACE_LAYER 100

@interface RunningLayer : CCLayerColor<SimulationObserver>
+ (CCScene *)scene;
@end
