//
// Created by najati on 9/25/12.
//

#import "Guy.h"
#import "Polygon.h"

@interface MeleeAttack : NSObject
@property(nonatomic, retain) Guy *guy;
@property(nonatomic, readonly) CGPolygon polygon;
@property(nonatomic, readonly) BOOL isDead;

- (id)init:(Guy *)_guy;

- (void)update:(ccTime)dt;
@end