#import <Foundation/Foundation.h>
#import "ccTypes.h"

@class Egg;
@class Trampoline;

@interface TrampolineSpring : NSObject

@property(nonatomic, retain) Egg *egg;
@property(nonatomic, retain) Trampoline *trampoline;
@property(nonatomic) bool alive;

- (id)initFor:(Trampoline *)trampoline and:(Egg *)and;
- (void)update:(ccTime)dt;

@end