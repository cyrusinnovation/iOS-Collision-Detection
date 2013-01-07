//
// by najati 
// copyright Cyrus Innovation
//

#import "EnterAndExitTicker.h"

@implementation EnterAndExitTicker {
	Simulation *simulation;
	Camera *camera;

	NSMutableArray *onScreenElements;
	id <ElementOnScreenObserver> listener;
}

- (id)init:(Simulation *)_simulation camera:(Camera *)_camera listener:(id <ElementOnScreenObserver>)_listener {
	self = [super init];
	if (!self) return self;

	simulation = _simulation;
	camera = _camera;
	listener = _listener;

	onScreenElements = [[NSMutableArray alloc] initWithCapacity:10];

	return self;
}

- (void)update:(ccTime)dt {
	CGRect cameraRect = [camera currentRect];

	for (int i = onScreenElements.count - 1; i >= 0; i--) {
		id <BoundedPolygon, SimulationActor> element = [onScreenElements objectAtIndex:i];
		if ([element expired] || ![self overlaps:element with:cameraRect]) {
			[listener elementLeftView:element];
			[onScreenElements removeObjectAtIndex:i];
		}
	}

	[self findElementsOnScreen:cameraRect elements:simulation.environment];
	[self findElementsOnScreen:cameraRect elements:simulation.characters];
	[self findElementsOnScreen:cameraRect elements:simulation.actors];
}

- (void)findElementsOnScreen:(CGRect)cameraRect elements:(NSMutableArray *)elements {
	for (id <BoundedPolygon, SimulationActor> element in elements) {
		if (![element expired] && [self overlaps:element with:cameraRect] && ![onScreenElements containsObject:element]) {
			[onScreenElements addObject:element];
			[listener elementEnteredView:element];
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