//
// Created by najati on 9/24/12.
//

#import "Stage.h"
#import "Polygon.h"

@implementation Stage {
	NSMutableArray *walls;
	float right_edge;
	float min_platform_length;
	float max_platform_length;

	float min_jump_distance;
	float max_jump_distance;
}

@synthesize walls;

- (id)init {
	if (self = [super init]) {
		walls = [[NSMutableArray alloc] init];
		right_edge = 0;

		min_platform_length = 400;
		max_platform_length = 700;

		min_jump_distance = 100;
		max_jump_distance = 170;
	}
	return self;
}

- (void)addWall:(CGPolygon)polygon {
	[walls addObject:[NSValue value:&polygon withObjCType:@encode(CGPolygon)]];

	for (int i = 0; i < polygon.count; i++) {
		if (polygon.points[i].x > right_edge) {
			right_edge = polygon.points[i].x;
		}
	}
}

- (void)dealloc {
	[walls release];
	[super dealloc];
}

- (void)generateAround:(CGPoint)point {
	point = cgp_add(point, cgp(max_jump_distance + max_platform_length, 0));
	if (point.x > right_edge) {
		float jump_distance = [self nextJumpDistance];
		float platformLength = [self nextPlatformLength];

		NSLog(@"next jump distance: %f next platform length: %f", jump_distance, platformLength);

		int height = 50 + rand() % 3 * 30;
		float x2 = right_edge + jump_distance + platformLength;
		[self addWall:make_block(right_edge + jump_distance, -50, x2, height)];
		
		if (rand() % 10 < 2) {
			[self addWall:make_block(x2, -50, x2 + [self nextPlatformLength], height + 200)];
			[self addWall:make_block(x2 - 100, height + 100, x2 - 80, height + 300)];
		}
	}
}

- (float)nextJumpDistance {
	return min_jump_distance + (rand() % (int) (max_jump_distance - min_jump_distance));
}

- (float)nextPlatformLength {
	return min_platform_length + (rand() % (int) (max_platform_length - min_platform_length));
}

@end