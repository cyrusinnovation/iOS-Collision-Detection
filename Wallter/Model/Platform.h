//
// Created by najati on 9/27/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Polygon.h"

@interface Platform : NSObject
@property(nonatomic, readonly) float right;
@property(nonatomic, readonly) CGPolygon polygon;
- (id)init:(CGPolygon) poly;
+ (Platform *)from:(CGPolygon)polygon;
@end