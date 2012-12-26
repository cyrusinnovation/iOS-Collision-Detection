//
// by najati 
// copyright Cyrus Innovation
//

#import "EnterAndExitTicker.h"

@implementation EnterAndExitTicker {
	Simulation *simulation;
	Camera *camera;

	NSMutableSet *onScreenElements;
	id <ElementOnScreenObserver> listener;
}

- (id)init:(Simulation *)_simulation camera:(Camera *)_camera listener:(id <ElementOnScreenObserver>)_listener {
	self = [super init];
	if (!self) return self;

	simulation = _simulation;
	camera = _camera;
	listener = _listener;

	onScreenElements = [[NSMutableSet alloc] initWithCapacity:10];

	return self;
}

- (void)update:(ccTime)dt {
	CGRect cameraRect = [camera currentRect];

	BOOL (^overlaps)(id, NSDictionary *) = ^BOOL(id <BoundedPolygon> platform, NSDictionary *dictionary) {
		return ![self overlaps:platform with:cameraRect];
	};
	NSSet *deadElements = [onScreenElements filteredSetUsingPredicate:[NSPredicate predicateWithBlock:overlaps]];

	for (id <BoundedPolygon> platform in deadElements) {
		[onScreenElements removeObject:platform];
		[listener platformLeftView:platform];
	}

	[self findElementsOnScreen:cameraRect elements:simulation.environment];
	[self findElementsOnScreen:cameraRect elements:simulation.characters];
}

- (void)findElementsOnScreen:(CGRect)cameraRect elements:(NSMutableArray *)elements {
	for (id <BoundedPolygon> element in elements) {
		if ([self overlaps:element with:cameraRect] && ![onScreenElements containsObject:element]) {
			[onScreenElements addObject:element];
			[listener platformEnteredView:element];
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