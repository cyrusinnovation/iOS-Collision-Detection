//
// by najati 
// copyright Cyrus Innovation
//


@protocol WalterObserver;
@class ProxyCollection;

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

+ (Walter *)from:(NSObject<WalterSimulationActor,WalterObserver> *)actor and:(NSObject<WalterWeapon,WalterObserver> *)weapon;

- (id)init:(NSObject<WalterSimulationActor,WalterObserver> *)actor weapon:(NSObject<WalterWeapon,WalterObserver> *)weapon;
@property(nonatomic, readonly, strong) ProxyCollection<WalterObserver> *observer;

@end