//
// Created by najati on 9/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DrawOffset.h"
#import "CGPoint_ops.h"

@implementation DrawOffset {
	Guy *guy;
	CGPoint delta;
}

- (id)init:(Guy *)_guy {
	if (self = [super init]) {
		guy = _guy;
		delta = cgp(160, 240);
	}
	return self;
}

-(void) update {
	float y = 80;

	int x = 50;
	if (!guy.runningRight) {
		x = 430;
	}

	CGPoint target_delta = cgp(x, y);
	CGPoint difference = cgp_subtract(target_delta, delta);
	cgp_scale(&difference, 0.02);
	delta = cgp_add(delta, difference);
//	delta = target_delta;
}

- (CGPoint)getOffset {
	return cgp_add(cgp(-guy.location.x, - guy.location.y), delta);
}

@end