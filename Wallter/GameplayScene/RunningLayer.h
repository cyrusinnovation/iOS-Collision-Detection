//
// najati
// copyright cyrus innovation
//

@class WalterWeapon;
@class WalterSimulationActor;
@class Simulation;
@class AudioPlayer;

#define INTERFACE_LAYER 100

@interface RunningLayer : CCLayerColor
+ (CCScene *)scene;

- (id)init:(WalterSimulationActor *)_walterActor and:(WalterWeapon *)_walterWeapon and:(Simulation *)_simulation audioPlayer:(AudioPlayer *)_audioPlayer;
@end
