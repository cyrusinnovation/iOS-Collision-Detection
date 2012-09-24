//
// Created by najati on 9/24/12.
//

#import "GuyView.h"
#import "CCDrawingPrimitives.h"

@implementation GuyView {
	Guy *guy;
	ccColor4F color;
}

@synthesize guy;

- (id)init:(Guy *)_guy {
	if (self = [super init]) {
		guy = _guy;
		color = (ccColor4F) {0.2456, 0.4588, 0.1882, 1.0};
	}
	return self;
}

- (void)draw {
	[super draw];
	ccDrawSolidPoly(guy.polygon.points, guy.polygon.count, color);
}

- (void)dealloc {
	[guy release];
	[super dealloc];
}

@end