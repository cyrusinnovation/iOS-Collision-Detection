//
// Created by najati on 9/25/12.
//

#import "Walter.h"
#import "Polygon.h"

@interface MeleeAttack : NSObject
@property(nonatomic, retain) Walter *guy;
@property(nonatomic, readonly) CGPolygon polygon;
@property(nonatomic, readonly) BOOL isDead;

- (id)init:(Walter *)_guy;

- (void)update:(ccTime)dt;
@end