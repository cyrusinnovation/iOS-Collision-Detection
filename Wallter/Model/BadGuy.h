//
// Created by najati on 9/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Polygon.h"

@interface BadGuy : NSObject
@property(nonatomic, readonly) CGPolygon polygon;

- (id)init:(CGPoint)point;
@end