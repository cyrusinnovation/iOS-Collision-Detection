//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Wall.h"


@implementation Wall {
	CGRect rectangle;
}
@synthesize rectangle;


+ (NSMutableArray *)wallsFrom:(NSMutableArray *)array {
	NSMutableArray *walls = [[NSMutableArray alloc] init];
	for (NSValue *value in array) {
		CGRect rectangle;
		[value getValue:&rectangle];
		[walls addObject:[[Wall alloc] init:rectangle]];
	}
	return walls;
}

- (id)init:(CGRect)_rectangle {
	if (self = [super init]) {
		rectangle = _rectangle;
	}
	return self;
}

@end