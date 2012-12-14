//
// Created by najati on 9/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Camera.h"
#import "CGPoint_ops.h"

@implementation Camera {
	Walter *guy;
	CGPoint delta;
}

- (id)init:(Walter *)_guy {
	if (self = [super init]) {
		guy = _guy;
		delta = cgp(160, 240);
	}
	return self;
}

// TODO this should probably be made aware of the update interval so the rate of
// return is consistent across framerates
-(void) update {
	[self moveCloserToDesiredOffset];
}

- (void)moveCloserToDesiredOffset {
	CGPoint desiredCameraOffset = [self getDesiredCameraOffset];
	CGPoint difference = cgp_subtract(desiredCameraOffset, delta);
	cgp_scale(&difference, RATE_OF_RETURN);
	delta = cgp_add(delta, difference);
}

- (CGPoint)getDesiredCameraOffset {
	float y = Y_OFFSET;

	int x = X_OFFSET_WHEN_RUNNING_RIGHT;
	if (!guy.runningRight) {
		x = X_OFFSET_WHEN_RUNNING_LEFT;
	}

	CGPoint target_delta = cgp(x, y);
	return target_delta;
}

- (CGPoint)getOffset {
	return cgp_subtract(delta, guy.location);
}

@end