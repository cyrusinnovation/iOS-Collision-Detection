//
// Created by najati on 12/14/12.
//

#import "PlatformAddedObserver.h"
#import "Simulation.h"

@protocol CharacterAddedObserver;

@interface AddBadGuyToStageObserver : NSObject<PlatformAddedObserver>
@property (nonatomic, retain) NSObject <CharacterAddedObserver> *characterAddedObserver;
- (id)init:(Simulation *)simulation;
@end