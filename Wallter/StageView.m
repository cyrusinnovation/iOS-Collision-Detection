//
// Created by najati on 9/24/12.
//

#import "StageView.h"
#import "CCDrawingPrimitives.h"

@implementation StageView {
	ccColor4F color;
	Stage *stage;
}

- (id)init:(Stage *)_stage {
	if (self = [super init]) {
		stage = _stage;
		color = (ccColor4F) {0.8588, 0.4588, 0.1882, 1.0};
	}
	return self;
}

- (void)draw {
	[super draw];
	for (NSValue *wallObject in stage.walls) {
		CGPolygon wall;
		[wallObject getValue:&wall];
		ccDrawSolidPoly(wall.points, wall.count, color);
	}
}

@end