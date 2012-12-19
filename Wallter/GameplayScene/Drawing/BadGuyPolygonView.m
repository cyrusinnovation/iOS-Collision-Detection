//
// Created by najati on 9/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BadGuyPolygonView.h"
#import "CCDrawingPrimitives.h"

@implementation BadGuyPolygonView {
	BadGuy *badguy;
	ccColor4F color;

	Camera *offset;
	CGPolygon drawPoly;
}

- (id)init:(BadGuy *)_badguy withOffset:(Camera *) _offset {
	if (self = [super init]) {
		[self scheduleUpdate];

		badguy = _badguy;
		offset = _offset;
		color = (ccColor4F) {0.8, 0.2, 0.8, 1.0};

		drawPoly = polygon_from(4, cgp(0, 0), cgp(0, 0), cgp(0, 0), cgp(0, 0));
	}
	return self;
}

-(void)update:(ccTime) dt {
	if (badguy.dead) {
		[self removeFromParentAndCleanup:true];
	}
}

- (void)draw {
	[super draw];

	CGPoint delta = [offset getOffset];
	transform_polygon(badguy.polygon, delta, drawPoly);

	ccDrawSolidPoly(drawPoly.points, drawPoly.count, color);
}

- (void)dealloc {
	free_polygon(drawPoly);
}

@end