//
// Created by najati on 10/3/12.
//

#import "HighScore.h"

@implementation HighScore {
	NSString *name;
	float score;
}
@synthesize name;
@synthesize score;

+ (HighScore *)by:(NSString *)name of:(float)score {
	return [[HighScore alloc] initBy:name of:score];
}

- (id)initBy:(NSString *)_name of:(float)_score {
	if (self = [super init]) {
		name = _name;
		score = _score;
	}
	return self;
}
@end