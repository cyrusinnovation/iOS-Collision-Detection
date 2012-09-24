//
// Created by najati on 9/24/12.
//

#import "StageView.h"
#import "CCDrawingPrimitives.h"

@implementation StageView {
	ccColor4F color;
	Stage *stage;
	Guy *guy;
}

- (id)init:(Stage *)_stage following:(Guy *) _guy {
	if (self = [super init]) {
		stage = _stage;
		guy = _guy;
		color = (ccColor4F) {0.8588, 0.4588, 0.1882, 1.0};
	}
	return self;
}

- (void)draw {
	[super draw];

	CGPolygon localWall = polygon_from(4, cgp(0, 0), cgp(0, 0), cgp(0, 0), cgp(0, 0));
	CGPoint delta = cgp(-guy.location.x + 50, 20);

	for (NSValue *wallObject in stage.walls) {
		CGPolygon wall;
		[wallObject getValue:&wall];

		transform_polygon(wall, delta, localWall);
		ccDrawSolidPoly(localWall.points, localWall.count, color);
	}

	free_polygon(localWall);
}

@end