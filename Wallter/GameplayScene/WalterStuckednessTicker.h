//
// by najati 
// copyright Cyrus Innovation
//

#import "SimulationTicker.h"
#import "WalterSimulationActor.h"

@interface WalterStuckednessTicker : NSObject <SimulationTicker>
- (id)init:(WalterSimulationActor *)_walter;
@end