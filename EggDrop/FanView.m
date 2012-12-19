//
// Created by najati on 9/20/12.
//


#import "FanView.h"
#import "CCDrawingPrimitives.h"


@implementation FanView {
	Fan *fan;
	ccColor4F color;
}

- (id)init:(Fan *)_fan {
	if (self = [super init]) {
		fan = _fan;
		color = (ccColor4F) {0.8588, 0.4588, 0.1882, 1.0};
	}
	return self;
}


- (void)draw {
	[super draw];
	ccDrawSolidPoly(fan.polygon.points, fan.polygon.count, color);
}

@end