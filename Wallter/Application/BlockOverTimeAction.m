//
// by najati 
// copyright Cyrus Innovation
//

#import "BlockOverTimeAction.h"

@implementation BlockOverTimeAction {
	void (^block)(ccTime);
}

-(id)init:(void (^) (ccTime))_block duration:(float) duration {
	self = [super initWithDuration:duration];
	if (!self) return self;

	block = _block;

	return self;
}

-(void) update: (ccTime) t {
	block(t);
}

@end