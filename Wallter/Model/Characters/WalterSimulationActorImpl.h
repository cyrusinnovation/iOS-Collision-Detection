//
// Created by najati on 9/24/12.
//

#import "Stage.h"
#import "ccTypes.h"
#import "WorldConstants.h"

#import "WalterObserver.h"
#import "BoundedPolygon.h"
#import "SimulationActor.h"
#import "Walter.h"

@class ProxyCollection;

@interface WalterSimulationActorImpl : NSObject<WalterSimulationActor,WalterObservable>
- (id)initAt:(CGPoint)at;
@end