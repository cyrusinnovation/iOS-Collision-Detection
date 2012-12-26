//
// Created by najati on 12/14/12.
//

#import "PlatformAddedObserver.h"
#import "Simulation.h"
#import "BadGuyObserver.h"

@class AudioPlayer;

@interface AddBadGuyToStageObserver : NSObject<PlatformAddedObserver>
- (id)init:(Simulation *)_simulation;
@end