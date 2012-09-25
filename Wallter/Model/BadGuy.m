//
// Created by najati on 9/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import "BadGuy.h"
#import "Polygon.h"


@implementation BadGuy {
	CGPolygon polygon;
	bool dead;
}

@synthesize polygon;
@synthesize dead;

- (id)init:(CGPoint)point {
	if (self = [super init]) {
		polygon = make_block(point.x, point.y, point.x + 20, point.y + 30);
		dead = false;
	}
	return self;
}

- (void)kill {
	dead = true;
}

@end