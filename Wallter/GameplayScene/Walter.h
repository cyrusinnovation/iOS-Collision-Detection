//
// by najati 
// copyright Cyrus Innovation
//

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

@protocol WalterSimulationActor<BoundedPolygon, SimulationActor>
@property(nonatomic, readonly) CGFloat width;
@property(nonatomic, readonly) CGPoint location;
@property(nonatomic, readonly) BOOL runningRight;
- (void)correct:(CGPoint)delta;
- (JumpType)jump;
- (void)kill;
@end

@interface Walter : NSObject<WalterSimulationActor, WalterWeapon>

+ (Walter *)from:(WalterSimulationActorImpl *)actor and:(WalterWeaponImpl *)weapon;

- (id)init:(WalterSimulationActorImpl *)_actor weapon:(WalterWeaponImpl *)_weapon;
@property(nonatomic, readonly, strong) ProxyCollection<WalterObserver> *observer;

@end