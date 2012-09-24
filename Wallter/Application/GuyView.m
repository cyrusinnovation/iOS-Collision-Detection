//
// Created by najati on 9/24/12.
//

#import "GuyView.h"
#import "CCDrawingPrimitives.h"

@implementation GuyView {
	Guy *guy;
	ccColor4F color;
}

@synthesize guy;

- (id)init:(Guy *)_guy {
	if (self = [super init]) {
		guy = _guy;
		color = (ccColor4F) {0.2456, 0.4588, 0.1882, 1.0};
	}
	return self;
}

- (void)draw {
	[super draw];

	CGPolygon localWall = polygon_from(4, cgp(0, 0), cgp(0, 0), cgp(0, 0), cgp(0, 0));
	CGPoint delta = cgp(-guy.location.x + 50, 20);
	transform_polygon(guy.polygon, delta, localWall);

	ccDrawSolidPoly(localWall.points, localWall.count, color);
}

- (void)dealloc {
	[guy release];
	[super dealloc];
}

@end