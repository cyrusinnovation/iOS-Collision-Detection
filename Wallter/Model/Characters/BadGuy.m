//
// Created by najati on 9/25/12.
//

#import "BadGuy.h"

@implementation BadGuy {
	CGPolygon polygon;
	bool dead;
}

@synthesize polygon;
@synthesize dead;

@synthesize top;
@synthesize bottom;
@synthesize left;
@synthesize right;

- (id)init:(CGPoint)point {
	if (self = [super init]) {
		left = point.x;
		bottom = point.y;
		right = left + 20;
		top = bottom + 30;
		polygon = make_block(left, bottom, right, top);
		dead = false;
	}
	return self;
}


- (void)kill {
	dead = true;
}

@end