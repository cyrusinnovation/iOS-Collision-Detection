//
// by najati 
// copyright Cyrus Innovation
//

#import "SimulationTicker.h"
#import "Walter.h"
#import "Stage.h"

@interface WalterInTheSimulationTicker : NSObject<SimulationTicker>
- (id)init:(Walter *)_walter in:(Stage *)_stage;
@end