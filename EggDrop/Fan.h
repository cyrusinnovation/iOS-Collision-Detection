//
// Created by najati on 9/20/12.
//


#import <Foundation/Foundation.h>
#import "Polygon.h"

@interface Fan : NSObject

@property(nonatomic) CGPolygon polygon;

- (id)init:(CGPolygon)polygon;

@end