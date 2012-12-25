//
// by najati 
// copyright Cyrus Innovation
//

#import "EnterAndExitTicker.h"

@implementation EnterAndExitTicker {
	Simulation *simulation;
	Camera *camera;

	NSMutableSet *onScreenPlatforms;
	id <EnvironmentOnScreenObserver> listener;
}

- (id)init:(Simulation *)_simulation camera:(Camera *)_camera listener:(id <EnvironmentOnScreenObserver>)_listener {
	self = [super init];
	if (!self) return self;

	simulation = _simulation;
	camera = _camera;
	listener = _listener;

	onScreenPlatforms = [[NSMutableSet alloc] initWithCapacity:10];

	return self;
}

- (void)update:(ccTime)dt {
	CGRect cameraRect = [camera currentRect];

	BOOL (^overlaps)(id, NSDictionary *) = ^BOOL(id <BoundedPolygon> platform, NSDictionary *dictionary) {
		return ![self overlaps:platform with:cameraRect];
	};
	NSSet *deadPlatforms = [onScreenPlatforms filteredSetUsingPredicate:[NSPredicate predicateWithBlock:overlaps]];

	for (id <BoundedPolygon> platform in deadPlatforms) {
		[onScreenPlatforms removeObject:platform];
		[listener platformLeftView:platform];
	}

	for (id <BoundedPolygon> platform in simulation.environment) {
		if ([self overlaps:platform with:cameraRect] && ![onScreenPlatforms containsObject:platform]) {
			[onScreenPlatforms addObject:platform];
			[listener platformEnteredView:platform];
		}
	}
}

- (BOOL)overlaps:(id <BoundedPolygon>)poly with:(CGRect)rect {
	if (poly.right < rect.origin.x) return NO;
	if (poly.left > rect.origin.x + rect.size.width) return NO;
	if (poly.top < rect.origin.y) return NO;
	if (poly.bottom > rect.origin.y + rect.size.height) return NO;
	return YES;
}

@end