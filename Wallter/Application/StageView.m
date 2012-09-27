//
// Created by najati on 9/24/12.
//

#import "StageView.h"
#import "CCDrawingPrimitives.h"
#import "Platform.h"

@implementation StageView {
	ccColor4F color;
	Stage *stage;
	DrawOffset *offset;

	CGPolygon drawPoly;
}

- (id)init:(Stage *)_stage following:(DrawOffset *) _offset {
	if (self = [super init]) {
		stage = _stage;
		offset = _offset;
		color = (ccColor4F) {0.8588, 0.4588, 0.1882, 1.0};

		drawPoly = polygon_from(4, cgp(0, 0), cgp(0, 0), cgp(0, 0), cgp(0, 0));
	}
	return self;
}

- (void)draw {
	[super draw];

	CGPoint delta = [offset getOffset];

	for (Platform *wall in stage.walls) {
		transform_polygon(wall.polygon, delta, drawPoly);
		ccDrawSolidPoly(drawPoly.points, drawPoly.count, color);
	}
}

- (void)dealloc {
	free_polygon(drawPoly);
	[super dealloc];
}

@end