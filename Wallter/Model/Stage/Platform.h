//
// Created by najati on 9/27/12.
//

#import "SimulationActor.h"
#import "BoundedPolygon.h"
#import "Polygon.h"

@interface Platform : NSObject<BoundedPolygon,SimulationActor>

@property(nonatomic, readonly) CGPolygon polygon;

@property(nonatomic, readonly) float right;
@property(nonatomic, readonly) float left;
@property(nonatomic, readonly) float center;
@property(nonatomic, readonly) float top;
@property(nonatomic, readonly) float bottom;
@property(nonatomic, readonly) float width;
@property(nonatomic, readonly) float height;

@property(nonatomic) BOOL expired;

- (id)init:(CGPolygon) poly;
+ (Platform *)from:(CGPolygon)polygon;

@end