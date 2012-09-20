//
// Created by najati on 9/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
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