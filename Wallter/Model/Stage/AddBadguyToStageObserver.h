//
// Created by najati on 12/14/12.
//

#import "PlatformAddedObserver.h"
#import "Simulation.h"
#import "BadGuyObserver.h"

@protocol SimulationObserver;
@protocol BadGuyObserver;
@class AudioPlayer;

@interface AddBadGuyToStageObserver : NSObject<PlatformAddedObserver, BadGuyObserver>
- (id)init:(Simulation *)_simulation audio:(AudioPlayer *)_audio;
@end