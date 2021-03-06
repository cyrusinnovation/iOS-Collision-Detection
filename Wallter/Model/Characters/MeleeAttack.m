//
// Created by najati on 9/25/12.
//

#import "MeleeAttack.h"

@implementation MeleeAttack {
	id<WalterSimulationActor> walterActor;
	CGPolygon polygon;
	ccTime age;
	ccTime max_age;
}

@synthesize polygon;

- (id)init:(id<WalterSimulationActor>)_walterActor {
	if (self = [super init]) {
		walterActor = _walterActor;
		polygon = make_block(0, 0, 0, 0);
		max_age = 0.1;
	}
	return self;
}

- (CGFloat)top {
	return polygon.points[2].y;
}

- (CGFloat)bottom {
	return polygon.points[0].y;
}

- (CGFloat)left {
	return polygon.points[0].x;
}

- (CGFloat)right {
	return polygon.points[2].x;
}

- (void)dealloc {
	free_polygon(polygon);
}

- (BOOL)facingRight {
	return walterActor.facingRight;
}

- (void)collides:(SATResult)result with:(id <BoundedPolygon>)that {
}

- (BOOL)expired {
	return age > max_age;
}

- (void)update:(ccTime)dt {
	age += dt;

	int attack_width = MELEE_ATTACK_WIDTH;
	if (walterActor.facingRight) {
		CGPolygon guyPoly = walterActor.polygon;
		polygon.points[0] = guyPoly.points[1];
		polygon.points[1] = guyPoly.points[1];
		polygon.points[1].x += attack_width;

		polygon.points[3] = guyPoly.points[2];
		polygon.points[2] = guyPoly.points[2];
		polygon.points[2].x += attack_width;
	} else {
		CGPolygon guyPoly = walterActor.polygon;
		polygon.points[0] = guyPoly.points[0];
		polygon.points[0].x -= attack_width;
		polygon.points[1] = guyPoly.points[0];

		polygon.points[2] = guyPoly.points[3];
		polygon.points[3] = guyPoly.points[3];
		polygon.points[3].x -= attack_width;
	}
}

@end