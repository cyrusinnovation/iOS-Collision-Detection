//
// Created by najati on 9/24/12.
//

#import "Guy.h"
#import "Stage.h"

@interface Simulation : NSObject

@property(nonatomic, retain) Guy *guy;
@property(nonatomic, retain) Stage *stage;
- (id)initFor:(Guy *)_guy in:(Stage *)_stage;

- (void)update:(ccTime)dt;

@end