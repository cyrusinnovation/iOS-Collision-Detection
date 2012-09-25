//
// Created by najati on 9/25/12.
//

#import "MeleeAttackView.h"
#import "CCDrawingPrimitives.h"
#import "Polygon.h"
#import "Guy.h"

ccColor4F color;

@implementation MeleeAttackView {
	MeleeAttack *attack;
}

- (id)init:(MeleeAttack *)_attack {
	if (self = [super init]) {
		attack = _attack;
		[self scheduleUpdate];

		color = (ccColor4F) {1.0, 1.0, 1.0, 1.0};
	}
	return self;
}

-(void) update:(ccTime) dt {
	if (attack.isDead) {
		[self removeFromParentAndCleanup:true];
	}
}

-(void) draw {
	CGPolygon localPoly = polygon_from(4, cgp(0, 0), cgp(0, 0), cgp(0, 0), cgp(0, 0));
	float y = 20;
	int margin = 200;
	if (attack.guy.location.y > margin) {
		y = - attack.guy.location.y + margin + 20;
	}
	CGPoint delta = cgp(-attack.guy.location.x + 50, y);
	transform_polygon(attack.polygon, delta, localPoly);

	ccDrawSolidPoly(localPoly.points, localPoly.count, color);
}

@end