//
// Created by najati on 9/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Polygon.h"

@interface Fan : NSObject

@property(nonatomic) CGPolygon polygon;

- (id)init:(CGPolygon)polygon;

@end