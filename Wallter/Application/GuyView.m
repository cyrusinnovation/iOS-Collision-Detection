//
// Created by najati on 9/24/12.
//

#import "GuyView.h"
#import "CCDrawingPrimitives.h"

@implementation GuyView {
	Guy *guy;
	ccColor4F color;

	CGPolygon drawPoly;
	DrawOffset *offset;
}

@synthesize guy;

- (id)init:(Guy *)_guy following:(DrawOffset *) _offset {
	if (self = [super init]) {
		guy = _guy;
		offset = _offset;
		color = (ccColor4F) {0.2456, 0.4588, 0.1882, 1.0};

		drawPoly = polygon_from(4, cgp(0, 0), cgp(0, 0), cgp(0, 0), cgp(0, 0));
	}
	return self;
}

- (void)draw {
	[super draw];

	CGPoint delta = [offset getOffset];
	transform_polygon(guy.polygon, delta, drawPoly);

	ccDrawSolidPoly(drawPoly.points, drawPoly.count, color);
}

- (void)dealloc {
	[guy release];
	free_polygon(drawPoly);
	[super dealloc];
}

@end