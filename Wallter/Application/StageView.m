//
// Created by najati on 9/24/12.
//

#import "StageView.h"
#import "CCDrawingPrimitives.h"

@implementation StageView {
	ccColor4F color;
	Stage *stage;
	Guy *guy;

	CGPolygon localWall;
}

- (id)init:(Stage *)_stage following:(Guy *) _guy {
	if (self = [super init]) {
		stage = _stage;
		guy = _guy;
		color = (ccColor4F) {0.8588, 0.4588, 0.1882, 1.0};

		localWall = polygon_from(4, cgp(0, 0), cgp(0, 0), cgp(0, 0), cgp(0, 0));
	}
	return self;
}

- (void)draw {
	[super draw];

	CGPoint delta = [self getOffset];

	for (NSValue *wallObject in stage.walls) {
		CGPolygon wall;
		[wallObject getValue:&wall];

		transform_polygon(wall, delta, localWall);
		ccDrawSolidPoly(localWall.points, localWall.count, color);
	}

	free_polygon(localWall);
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