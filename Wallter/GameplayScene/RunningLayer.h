//
// najati
// copyright cyrus innovation
//

@class Walter;
@class Simulation;
#define INTERFACE_LAYER 100

@interface RunningLayer : CCLayerColor
+ (CCScene *)scene:(Walter *)walter simulation:(Simulation *)simulation;
@end
