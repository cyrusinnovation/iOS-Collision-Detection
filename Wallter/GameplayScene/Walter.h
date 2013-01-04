//
// by najati 
// copyright Cyrus Innovation
//

#import "HasFacing.h"

@protocol WalterObserver;
@class ProxyCollection;
@class WalterSimulationActorImpl;
@class WalterWeaponImpl;

typedef enum {
	noJump,
	groundJump,
	wallJump
} JumpType;

@protocol WalterObservable
@property(nonatomic, readonly) ProxyCollection<WalterObserver> *observer;
@end

@protocol WalterWeapon
- (void)attack;
@end

@protocol WalterSimulationActor<BoundedPolygon, SimulationActor, HasFacing>
@property(nonatomic, readonly) CGFloat width;
@property(nonatomic, readonly) CGPoint location;
- (void)correct:(CGPoint)delta;
- (JumpType)jump;
- (void)kill;
@end

@interface Walter : NSObject<WalterSimulationActor, WalterWeapon, HasFacing>

+ (Walter *)from:(WalterSimulationActorImpl *)actor and:(WalterWeaponImpl *)weapon;

- (id)init:(WalterSimulationActorImpl *)_actor weapon:(WalterWeaponImpl *)_weapon;
@property(nonatomic, readonly, strong) ProxyCollection<WalterObserver> *observer;

@end