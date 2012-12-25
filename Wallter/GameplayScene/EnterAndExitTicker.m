//
// by najati 
// copyright Cyrus Innovation
//

#import "EnterAndExitTicker.h"

@implementation EnterAndExitTicker {
	Simulation *simulation;
	Camera *camera;

	NSMutableSet *onScreenPlatforms;
}

- (id)init:(Simulation *)_simulation camera:(Camera *)_camera {
	self = [super init];
	if (!self) return self;
	
	simulation = _simulation;
	camera = _camera;
	onScreenPlatforms = [[NSMutableSet alloc] initWithCapacity:10];

	return self;
}

- (void)update:(ccTime)dt {
	CGRect cameraRect = [camera currentRect];
	CGPoint offset = [camera getOffset];

	CGPoint start = cgp_subtract(cameraRect.origin, offset);
	CGPoint end = cgp_add(start, cgp(cameraRect.size.width, cameraRect.size.height));

	ccDrawRect(start, end);
	ccDrawRect(cgp(10, 10), cgp(20, 20));

	for (id<BoundedPolygon> platform in simulation.environment) {

	}

	for (id<BoundedPolygon> platform in onScreenPlatforms) {

	}
}

@end