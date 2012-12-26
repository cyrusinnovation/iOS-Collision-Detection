//
// Created by najati on 9/24/12.
//

#import "Stage.h"
#import "ccTypes.h"
#import "WorldConstants.h"

#import "WalterObserver.h"
#import "BoundedPolygon.h"
#import "SimulationActor.h"

@class ProxyCollection;

typedef enum {
	noJump,
	groundJump,
	wallJump
} JumpType;

@interface WalterSimulationActor : NSObject<BoundedPolygon, SimulationActor>
@property(nonatomic) CGPoint location;

@property(nonatomic,readonly) BOOL runningRight;
@property(nonatomic, readonly) CGFloat bottom;
@property(nonatomic, readonly) CGFloat top;
@property(nonatomic, readonly) CGFloat left;
@property(nonatomic, readonly) CGFloat right;
@property(nonatomic, readonly) CGFloat width;

@property(nonatomic, readonly, strong) ProxyCollection<WalterObserver> *observer;

- (id)initAt:(CGPoint)at;
- (CGPolygon)polygon;

- (void)correct:(CGPoint)delta;

- (JumpType)jump;

- (void)kill;
@end