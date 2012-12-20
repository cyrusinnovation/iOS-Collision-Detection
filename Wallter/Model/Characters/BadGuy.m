//
// Created by najati on 9/25/12.
//

#import "BadGuy.h"
#import "MeleeAttack.h"
#import "SimpleAudioEngine.h"

@implementation BadGuy

@synthesize polygon;
@synthesize dead;
@synthesize facingRight;

@synthesize top;
@synthesize bottom;
@synthesize left;
@synthesize right;

- (id)init:(CGPoint)point facingRight:(Boolean)_facingRight {
	self = self = [super init];
	if (!self) return self;

	dead = false;
	facingRight = _facingRight;

	left = point.x;
	bottom = point.y;
	right = left + 20;
	top = bottom + 30;
	polygon = make_block(left, bottom, right, top);

	return self;
}

- (Boolean)isExpired {
	return dead;
}

- (void)collides:(SATResult)result with:(id <BoundedPolygon>)that {
	if (dead) return;
	if ([that isMemberOfClass:[MeleeAttack class]]) {
		dead = true;
		// TODO for the love of God ...
		[[SimpleAudioEngine sharedEngine] playEffect:@"DSPODTH3.WAV"];
	}
}

- (void)update:(ccTime)dt {
}

@end