//
// Created by najati on 9/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DrawOffset.h"
#import "CGPoint_ops.h"

@implementation DrawOffset {

	Guy *guy;
}

- (id)init:(Guy *)_guy {
	if (self = [super init]) {
		guy = _guy;
	}
	return self;
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