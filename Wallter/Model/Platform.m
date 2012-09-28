//
// Created by najati on 9/27/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Platform.h"
#import "SeparatingAxisTest.h"

@implementation Platform {
	CGPolygon polygon;
	float right;
	float left;
	float center;
	float top;
	float bottom;
}

@synthesize polygon;

@synthesize right;
@synthesize left;
@synthesize center;
@synthesize top;
@synthesize bottom;


+ (Platform *)from:(CGPolygon)polygon {
	return [[Platform alloc] init:polygon];
}

- (id)init:(CGPolygon)_polygon {
	if (self = [super init]) {
		polygon = _polygon;

		right = FLT_MIN;
		left = FLT_MAX;
		top = FLT_MIN;
		bottom = FLT_MAX;

		for (int i = 0; i < polygon.count; i++) {
			CGPoint point = polygon.points[i];
			if (point.x < left) {
				left = point.x;
			}
			if (point.x > right) {
				right = point.x;
			}

			if (point.y > top) {
				top = point.y;
			}
			if (point.y < bottom) {
				bottom = point.y;
			}
		}

		center = (left + right) / 2;
	}
	return self;
}

- (void)dealloc {
	free_polygon(polygon);
	[super dealloc];
}

- (SATResult)test:(Guy *)guy {
	if (guy.bottom > top ||
			guy.top < bottom ||
			guy.right < left ||
			guy.left > right) {
		return (SATResult) {cgp(0, 0), false};
	}
	SATResult result = sat_test(guy.polygon, polygon);
	return result;
}
@end