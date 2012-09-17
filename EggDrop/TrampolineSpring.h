#import <Foundation/Foundation.h>
#import "ccTypes.h"

@class Egg;
@class Trampoline;

@interface TrampolineSpring : NSObject

@property(nonatomic, retain) Egg *egg;

- (id)initFrom:(CGPoint)left to:(CGPoint)right for:(Egg *)_egg;

- (void)update:(ccTime)dt;

- (BOOL)alive;


- (CGPoint)bend;
@end