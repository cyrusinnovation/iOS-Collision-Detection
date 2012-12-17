//
// Created by najati on 9/24/12.
//

#import "WalterPolygonView.h"
#import "CCDrawingPrimitives.h"
#import "CCSpriteFrameCache.h"

@implementation WalterPolygonView {
	Walter *walter;
	ccColor4F color;

	CGPolygon drawPoly;
	Camera *offset;
}

- (id)init:(Walter *)_guy following:(Camera *) _offset {
	if (self = [super init]) {
		walter = _guy;
		offset = _offset;
		color = (ccColor4F) {0.2456, 0.4588, 0.1882, 1.0};

		drawPoly = polygon_from(4, cgp(0, 0), cgp(0, 0), cgp(0, 0), cgp(0, 0));
	}
	return self;
}

- (void)draw {
	CGPoint delta = [offset getOffset];

	transform_polygon(walter.polygon, delta, drawPoly);
	ccDrawSolidPoly(drawPoly.points, drawPoly.count, color);

	[super draw];
}

- (void)dealloc {
	free_polygon(drawPoly);
}

@end