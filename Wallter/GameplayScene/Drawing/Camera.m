//
// Created by najati on 9/26/12.
//


#import "Camera.h"
#import "BadGuyView.h"

@implementation Camera {
	Walter *guy;
	CGPoint delta;
}

@synthesize scale;

- (id)init:(Walter *)_guy {
	if (self = [super init]) {
		guy = _guy;
		delta = cgp(160, 240);
		scale = 0.5;
	}
	return self;
}

// TODO this should probably be made aware of the update interval so the rate of
// return is consistent across framerates
- (void)update {
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
	// TODO maybe this should be computed in update
	return cgp_subtract(delta, guy.location);
}

- (void)transform:(CCSprite *)sprite to:(id <BoundedPolygon>)location {
	CGPoint currentDelta = [self getOffset];

	// TODO take as precondition?
	[sprite setAnchorPoint:cgp(0.5, 0)];
	CGPoint position = cgp_add(cgp((location.left + location.right) / 2, location.bottom), currentDelta);
	cgp_scale(&position, scale);
	[sprite setPosition:position];
}

- (void)transform:(CGPolygon)polygon into:(CGPolygon)into {
	CGPoint currentDelta = [self getOffset];
	transform_polygon(polygon, currentDelta, into);
	scale_polygon(into, scale, into);
}

@end