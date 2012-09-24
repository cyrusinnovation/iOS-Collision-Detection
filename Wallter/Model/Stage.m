//
// Created by najati on 9/24/12.
//

#import "Stage.h"

@implementation Stage {
	NSMutableArray *walls;
}

@synthesize walls;

- (id)init {
	if (self = [super init]) {
		walls = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addWall:(CGPolygon)polygon {
	[walls addObject:[NSValue value:&polygon withObjCType:@encode(CGPolygon)]];
}

- (void)dealloc {
	[walls release];
	[super dealloc];
}

@end