//
// Created by najati on 9/20/12.
//


#import "Fan.h"

@implementation Fan

@synthesize polygon;

- (id)init:(CGPolygon)_polygon {
	if (self = [super init]) {
		polygon = _polygon;
	}
	return self;
}

@end