//
// by najati 
// copyright Cyrus Innovation
//

#import "SimulationTicker.h"
#import "WalterSimulationActorImpl.h"

@interface WalterStuckednessTicker : NSObject <SimulationTicker>
- (id)init:(Walter *)_walter;
@end