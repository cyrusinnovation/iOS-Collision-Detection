//
// Created by najati on 9/25/12.
//


#import <Foundation/Foundation.h>
#import "Polygon.h"
#import "BoundedPolygon.h"
#import "SimulationActor.h"

@interface BadGuy : NSObject<BoundedPolygon, SimulationActor>

@property(nonatomic, readonly) CGPolygon polygon;
@property(nonatomic, readonly) bool dead;
@property(nonatomic, readonly) bool facingRight;

- (id)init:(CGPoint)point facingRight:(BOOL)_facingRight;

@end