//
// by najati 
// copyright Cyrus Innovation
//

#import "CCLabelBMFont.h"
#import "ScoreLabel.h"

@implementation ScoreLabel {
	float score;
}

- (id)initAt:(CGPoint) location {
	self = [super initWithString:@"0" fntFile:@"font.fnt"];
	if (!self) return self;

	[self scheduleUpdate];
	self.position = location;

	score = 0;

	return self;
}

- (void)update:(ccTime)dt {
	score += dt * 21;
	[self setString:[NSString stringWithFormat:@"%d", (int) score]];
}

@end