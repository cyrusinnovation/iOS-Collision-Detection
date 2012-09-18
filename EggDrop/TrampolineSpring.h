#import <Foundation/Foundation.h>
#import "ccTypes.h"

@class Egg;
@class Trampoline;

@interface TrampolineSpring : NSObject

@property(nonatomic, retain) Egg *egg;

- (id)initFrom:(CGPoint)left to:(CGPoint)right for:(Egg *)_egg springConstant:(float) _springConstant damping:(float)_damping;

- (void)update:(ccTime)dt;

- (BOOL)alive;


- (CGPoint)bend;
@end