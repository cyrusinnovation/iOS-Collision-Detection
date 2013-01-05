//
// Created by najati on 9/27/12.
//

#import "SimulationActor.h"
#import "BoundedPolygon.h"
#import "Polygon.h"
#import "HasFacing.h"

@interface Platform : NSObject<BoundedPolygon,SimulationActor,HasFacing>

@property(nonatomic, readonly) CGPolygon polygon;

@property(nonatomic, readonly) float center;
@property(nonatomic, readonly) float width;
@property(nonatomic, readonly) float height;

@property(nonatomic) BOOL expired;

- (id)init:(CGPolygon) poly;
+ (Platform *)from:(CGPolygon)polygon;

@end