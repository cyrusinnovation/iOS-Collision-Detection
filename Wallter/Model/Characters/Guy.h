//
// Created by najati on 9/24/12.
//

#import "Stage.h"
#import "ccTypes.h"
#import "WorldConstants.h"

typedef enum {
	noJump,
	groundJump,
	wallJump
} JumpType;

@interface Guy : NSObject
@property(nonatomic) CGPoint location;

@property(nonatomic,readonly) BOOL runningRight;
@property(nonatomic, readonly) bool dead;
@property(nonatomic, readonly) CGFloat bottom;
@property(nonatomic, readonly) CGFloat top;
@property(nonatomic, readonly) CGFloat left;
@property(nonatomic, readonly) CGFloat right;


- (id)initAt:(CGPoint)at;
- (CGPolygon)polygon;
- (void)update:(ccTime)dt;

- (void)correct:(CGPoint)delta;

- (JumpType)jumpLeft;

- (JumpType)jumpRight;

- (void)kill;
@end