//
// Created by najati on 9/24/12.
//

#import "StageView.h"
#import "CCDrawingPrimitives.h"
#import "Platform.h"

@implementation StageView {
	ccColor4F color;
	Stage *stage;
	Camera *offset;

	CGPolygon drawPoly;

	float scale;
}

- (id)init:(Stage *)_stage following:(Camera *) _offset {
	if (self = [super init]) {
		stage = _stage;
		offset = _offset;
		color = (ccColor4F) {0.8588, 0.4588, 0.1882, 1.0};

		drawPoly = polygon_from(4, cgp(0, 0), cgp(0, 0), cgp(0, 0), cgp(0, 0));

		scale = 0.5;
	}
	return self;
}

- (void)draw {
	[super draw];

	for (Platform *wall in stage.elements) {
		[offset transform:wall.polygon into: drawPoly];
		ccDrawSolidPoly(drawPoly.points, drawPoly.count, color);
	}
}

- (void)dealloc {
	free_polygon(drawPoly);
}

@end