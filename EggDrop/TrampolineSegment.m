//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TrampolineSegment.h"
#import "CGPoint_ops.h"


CGPoint start;

CGPoint end;

@implementation TrampolineSegment {

}

- (id)initFrom:(CGPoint)_start to:(CGPoint)_end {
	if (self = [super init]) {
		start = _start;
		end = _end;
	}
	return self;
}

- (CGPoint)center {
	CGPoint center = cgp_add(start, end);
	cgp_scale(&center, 0.5f);
	return center;
}

- (float)angle {
	CGPoint direction;
	if (start.x > end.x) {
		direction = cgp_subtract(start, end);
	} else {
		direction = cgp_subtract(end, start);
	}
	cgp_normalize(&direction);
	return 180 * acosf(cgp_dot(direction, cgp(0, 1))) / M_PI;
}

- (float)length {
	return cgp_length(cgp_subtract(end, start));
}

@end