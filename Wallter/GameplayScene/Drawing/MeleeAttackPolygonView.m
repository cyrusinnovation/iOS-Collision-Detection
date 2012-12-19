//
// Created by najati on 9/25/12.
//

#import "MeleeAttackPolygonView.h"
#import "Walter.h"
#import "CCDrawingPrimitives.h"

ccColor4F color;

@implementation MeleeAttackPolygonView {
	MeleeAttack *attack;
	CGPolygon drawPoly;
	Camera *offset;
}

- (id)init:(MeleeAttack *)_attack following:(Camera *) _offset {
	if (self = [super init]) {
		attack = _attack;
		offset = _offset;

		[self scheduleUpdate];

		color = (ccColor4F) {1.0, 1.0, 1.0, 1.0};

		drawPoly = polygon_from(4, cgp(0, 0), cgp(0, 0), cgp(0, 0), cgp(0, 0));
	}
	return self;
}

-(void) update:(ccTime) dt {
	if (attack.isExpired) {
		[self removeFromParentAndCleanup:true];
	}
}

-(void) draw {
	CGPoint delta = [offset getOffset];
	transform_polygon(attack.polygon, delta, drawPoly);
	ccDrawSolidPoly(drawPoly.points, drawPoly.count, color);
}

- (void)dealloc {
	free_polygon(drawPoly);
}

@end