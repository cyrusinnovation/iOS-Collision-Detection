//
// Created by najati on 9/27/12.
//

#import "Polygon.h"
#import "BoundedPolygon.h"

@interface Platform : NSObject<BoundedPolygon>

@property(nonatomic, readonly) CGPolygon polygon;

@property(nonatomic, readonly) float right;
@property(nonatomic, readonly) float left;
@property(nonatomic, readonly) float center;
@property(nonatomic, readonly) float top;
@property(nonatomic, readonly) float bottom;
@property(nonatomic, readonly) float width;

- (id)init:(CGPolygon) poly;

+ (Platform *)from:(CGPolygon)polygon;

@end