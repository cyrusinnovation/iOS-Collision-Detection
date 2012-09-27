//
// Created by najati on 9/27/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import "Platform.h"
#import "Polygon.h"

@implementation Platform {
	CGPolygon polygon;
	float right;
	float left;
	float middle;
	float top;
}

@synthesize polygon;

@synthesize right;
@synthesize left;
@synthesize middle;
@synthesize top;

+ (Platform *)from:(CGPolygon)polygon {
	return [[Platform alloc] init:polygon];
}

- (id)init:(CGPolygon) _polygon {
	if (self = [super init]) {
		polygon = _polygon;

		right = FLT_MIN;
		left = FLT_MAX;
		top = FLT_MIN;
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
		}

		middle = (left + right)/2;
	}
	return self;
}

-(void)dealloc {
	free_polygon(polygon);
	[super dealloc];
}

@end