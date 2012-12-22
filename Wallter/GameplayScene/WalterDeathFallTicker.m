//
// by najati 
// copyright Cyrus Innovation
//

#import "WalterDeathFallTicker.h"

@implementation WalterDeathFallTicker {
	Walter *walter;
	Stage *stage;
}

- (id)init:(Walter *)_walter in:(Stage *)_stage {
	self = [super init];
	if (!self) return self;
	
	walter = _walter;
	stage = _stage;
	
	return self;
}

- (void)update:(ccTime)dt {
	if (walter.location.y < stage.deathHeight) {
		[walter kill];
	} else {
		[stage generateAround:walter];
	}
}

@end