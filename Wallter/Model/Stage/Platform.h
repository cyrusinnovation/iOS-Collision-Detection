//
// Created by najati on 9/27/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Polygon.h"
#import "SATResult.h"
#import "Walter.h"

@interface Platform : NSObject

@property(nonatomic, readonly) CGPolygon polygon;

@property(nonatomic, readonly) float right;
@property(nonatomic, readonly) float left;
@property(nonatomic, readonly) float center;
@property(nonatomic, readonly) float top;
@property(nonatomic, readonly) float bottom;
@property(nonatomic, readonly) float width;

- (id)init:(CGPolygon) poly;

- (SATResult)test:(Walter *)guy;

+ (Platform *)from:(CGPolygon)polygon;

@end