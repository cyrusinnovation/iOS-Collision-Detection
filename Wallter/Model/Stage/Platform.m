//
// Created by najati on 9/27/12.
//

#import "Platform.h"

@implementation Platform

@synthesize polygon;

@synthesize right;
@synthesize left;
@synthesize center;
@synthesize top;
@synthesize bottom;
@synthesize width;
@synthesize height;

@synthesize expired;

+ (Platform *)from:(CGPolygon)polygon {
	return [[Platform alloc] init:polygon];
}

- (id)init:(CGPolygon)_polygon {
	if (self = [super init]) {
		expired = false;
		polygon = _polygon;

		right = -FLT_MAX;
		left = FLT_MAX;
		top = -FLT_MAX;
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

		width = right - left;
		height = top - bottom;
	}
	return self;
}

- (void)collides:(SATResult)result with:(id <BoundedPolygon>)that {
}

- (BOOL)expired {
	return expired;
}

- (void)update:(ccTime)dt {
}

- (void)dealloc {
	free_polygon(polygon);
}

@end