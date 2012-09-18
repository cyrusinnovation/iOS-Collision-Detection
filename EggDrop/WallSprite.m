//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <CoreGraphics/CoreGraphics.h>
#import "WallSprite.h"

@implementation WallSprite {
	Wall *wall;
}

- (id)init:(Wall *) _wall {
	if (self = [super initWithFile:@"wall.png" rect:_wall.rectangle]) {
		wall = _wall;

		[self setPosition:wall.rectangle.origin];

		ccTexParams params = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};

		[[self texture] setTexParameters:&params];
	}
	return self;
}

@end