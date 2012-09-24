//
// Created by najati on 9/24/12.
//

#import "Stage.h"

@interface Guy : NSObject
@property(nonatomic) CGPoint location;

- (id)initIn:(Stage *)stage at:(CGPoint)at;

- (CGPolygon)polygon;
@end