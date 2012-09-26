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
	Guy *guy;

	CGPolygon drawPoly;
}

- (id)init:(MeleeAttack *)_attack {
	if (self = [super init]) {
		attack = _attack;
		guy = attack.guy;
		[self scheduleUpdate];

		color = (ccColor4F) {1.0, 1.0, 1.0, 1.0};

		drawPoly = polygon_from(4, cgp(0, 0), cgp(0, 0), cgp(0, 0), cgp(0, 0));
	}
	return self;
}

-(void) update:(ccTime) dt {
	if (attack.isDead) {
		[self removeFromParentAndCleanup:true];
	}
}

-(void) draw {
	CGPoint delta = [self getOffset];
	transform_polygon(attack.polygon, delta, drawPoly);

	ccDrawSolidPoly(drawPoly.points, drawPoly.count, color);
}

- (void)dealloc {
	[attack release];
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