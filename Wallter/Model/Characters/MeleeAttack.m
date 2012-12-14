//
// Created by najati on 9/25/12.
//

#import "MeleeAttack.h"

@implementation MeleeAttack {
	Walter *guy;
	CGPolygon polygon;
	ccTime age;
	ccTime max_age;
}

@synthesize guy;

- (BOOL)isDead {
	return age > max_age;
}

- (id)init:(Walter *)_guy {
	if (self = [super init]) {
		guy = _guy;
		polygon = make_block(0, 0, 0, 0);
		max_age = 0.1;
	}
	return self;
}

- (CGPolygon)polygon {
	int attack_width = 70;
	if (guy.runningRight) {
		CGPolygon guyPoly = guy.polygon;
		polygon.points[0] = guyPoly.points[1];
		polygon.points[1] = guyPoly.points[1];
		polygon.points[1].x += attack_width;

		polygon.points[3] = guyPoly.points[2];
		polygon.points[2] = guyPoly.points[2];
		polygon.points[2].x += attack_width;
	} else {
		CGPolygon guyPoly = guy.polygon;
		polygon.points[0] = guyPoly.points[0];
		polygon.points[0].x -= attack_width;
		polygon.points[1] = guyPoly.points[0];

		polygon.points[2] = guyPoly.points[3];
		polygon.points[3] = guyPoly.points[3];
		polygon.points[3].x -= attack_width;
	}
	return polygon;
}

- (void)dealloc {
	free_polygon(polygon);
	[guy release];
	[super dealloc];
}

- (void)update:(ccTime)dt {
	age += dt;
}

@end