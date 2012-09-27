//
// Created by najati on 9/27/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Platform.h"

@implementation Platform {
	CGPolygon polygon;
	float right;
}

@synthesize polygon;
@synthesize right;

+ (Platform *)from:(CGPolygon)polygon {
	return [[Platform alloc] init:polygon];
}

- (id)init:(CGPolygon) _polygon {
	if (self = [super init]) {
		polygon = _polygon;

		right = FLT_MIN;
		for (int i = 0; i < polygon.count; i++) {
			if (polygon.points[i].x > right) {
				right = polygon.points[i].x;
			}
		}

	}
	return self;
}

-(void)dealloc {
	free_polygon(polygon);
}

@end