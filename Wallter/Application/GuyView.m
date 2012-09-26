//
// Created by najati on 9/24/12.
//

#import "GuyView.h"
#import "CCDrawingPrimitives.h"

@implementation GuyView {
	Guy *guy;
	ccColor4F color;

	CGPolygon drawPoly;
}

@synthesize guy;

- (id)init:(Guy *)_guy {
	if (self = [super init]) {
		guy = _guy;
		color = (ccColor4F) {0.2456, 0.4588, 0.1882, 1.0};

		drawPoly = polygon_from(4, cgp(0, 0), cgp(0, 0), cgp(0, 0), cgp(0, 0));
	}
	return self;
}

- (void)draw {
	[super draw];

	CGPoint delta = [self getOffset];
	transform_polygon(guy.polygon, delta, drawPoly);

	ccDrawSolidPoly(drawPoly.points, drawPoly.count, color);
}

- (void)dealloc {
	[guy release];
	free_polygon(drawPoly);
	[super dealloc];
}

- (CGPoint)getOffset {
	float y = 20;
	int margin = 200;
	if (guy.location.y > margin) {
		y = - guy.location.y + margin + 20;
	}
	CGPoint delta = cgp(-guy.location.x + 50, y);
	return delta;
}

@end