//
// Created by najati on 9/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Polygon.h"
#import "BoundedPolygon.h"

@interface BadGuy : NSObject<BoundedPolygon>

@property(nonatomic, readonly) CGPolygon polygon;
@property(nonatomic, readonly) bool dead;

- (id)init:(CGPoint)point;
- (void)kill;

@end