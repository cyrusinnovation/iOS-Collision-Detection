//
// Created by najati on 9/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BadGuyView.h"
#import "CCDrawingPrimitives.h"

@implementation BadGuyView {
	BadGuy *badguy;
	ccColor4F color;
	Guy *guy;
	CGPolygon drawPoly;
}

- (id)init:(BadGuy *)_badguy around:(Guy *) _guy {
	if (self = [super init]) {
		[self scheduleUpdate];

		badguy = _badguy;
		guy = _guy;
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

	CGPoint delta = [self getOffset];
	transform_polygon(badguy.polygon, delta, drawPoly);

	ccDrawSolidPoly(drawPoly.points, drawPoly.count, color);
}

- (void)dealloc {
	[badguy release];
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