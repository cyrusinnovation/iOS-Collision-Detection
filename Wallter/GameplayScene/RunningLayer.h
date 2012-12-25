//
// najati
// copyright cyrus innovation
//

#import "cocos2d.h"
#import "SimulationObserver.h"
#import "EnvironmentOnScreenObserver.h"

#define INTERFACE_LAYER 100

@interface RunningLayer : CCLayerColor<SimulationObserver, EnvironmentOnScreenObserver>
+ (CCScene *)scene;
@end
