//
// Created by najati on 9/24/12.
//

#import "Guy.h"

@implementation Guy {
	Stage *stage;
	CGPoint location;
	CGPoint size;
}

@synthesize location;

- (id)initIn:(Stage *)_stage at:(CGPoint)at {
	if (self = [super init]) {
		stage = _stage;
		location = at;
		size = cgp(10, 10);
	}
	return self;
}

- (CGPolygon)polygon {
	return make_block(location.x, location.y, location.x + size.y, location.y + size.y);
}

@end