//
// Created by najati on 9/24/12.
//

#import "Stage.h"
#import "ccTypes.h"
#import "WorldConstants.h"

#import "WalterObserver.h"


typedef enum {
	noJump,
	groundJump,
	wallJump
} JumpType;

@interface Walter : NSObject
@property(nonatomic) CGPoint location;

@property(nonatomic,readonly) BOOL runningRight;
@property(nonatomic, readonly) bool dead;
@property(nonatomic, readonly) CGFloat bottom;
@property(nonatomic, readonly) CGFloat top;
@property(nonatomic, readonly) CGFloat left;
@property(nonatomic, readonly) CGFloat right;
@property(nonatomic, readonly) CGFloat width;

@property(nonatomic, retain) NSObject <WalterObserver> *walterObserver;

- (id)initAt:(CGPoint)at;
- (CGPolygon)polygon;
- (void)update:(ccTime)dt;

- (void)correct:(CGPoint)delta;

- (JumpType)jumpLeft;

- (JumpType)jumpRight;

- (void)kill;

- (void)jump;
@end