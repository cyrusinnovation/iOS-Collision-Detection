//
// by najati 
// copyright Cyrus Innovation
//

#import "SimulationTicker.h"
#import "WalterSimulationActor.h"
#import "Stage.h"

@interface WalterInTheSimulationTicker : NSObject<SimulationTicker>
- (id)init:(WalterSimulationActor *)_walter in:(Stage *)_stage;
@end