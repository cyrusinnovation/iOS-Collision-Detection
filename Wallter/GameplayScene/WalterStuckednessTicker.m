//
// by najati 
// copyright Cyrus Innovation
//

#import "WalterStuckednessTicker.h"

@implementation WalterStuckednessTicker {
	CGPoint waltersLocation;
	ccTime timeAtCurrentPosition;

	Walter *walter;
}

- (id)init:(Walter *)_walter {
	self = [super init];
	if (!self) return self;

	walter = _walter;

	waltersLocation = walter.location;
	timeAtCurrentPosition = 0;

	return self;
}

- (void)update:(ccTime)dt {
	if (walter.location.x == waltersLocation.x && walter.location.y == waltersLocation.y) {
		timeAtCurrentPosition += dt;
		if (timeAtCurrentPosition > 1) {
			[walter kill];
		}
	} else {
		waltersLocation = walter.location;
	}
}

@end