//
// Created by najati on 9/17/12.
//


#import "Level.h"

@implementation Level {
	NSMutableArray *starLocations;
	NSMutableArray *wallLocations;
}

@synthesize initialEggLocation = _initialEggLocation;
@synthesize nestLocation = _nestLocation;
@synthesize starLocations;
@synthesize wallLocations;


- (id)init {
	if (self = [super init]) {
		starLocations = [[NSMutableArray alloc] init];
		wallLocations = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addStar:(CGPoint)location {
	[starLocations addObject:[NSValue value:&location withObjCType:@encode(CGPoint)]];
}

- (void)addWall:(CGRect)rectangle {
	[wallLocations addObject:[NSValue value:&rectangle withObjCType:@encode(CGRect)]];
}

- (void)dealloc {
	[starLocations release];
	[wallLocations release];
	[super dealloc];
}

@end