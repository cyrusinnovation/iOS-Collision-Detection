//
// Created by najati on 9/24/12.
//

#import "Stage.h"

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

- (void)generateAround:(CGPoint)point listener:(NSObject<NewPlatformListener> *)listener {
	point = cgp_add(point, cgp(max_jump_distance + max_platform_length, 0));
	if (point.x > right_edge) {
		float jump_distance = [self nextJumpDistance];
		float platformLength = [self nextPlatformLength];

		float height = 50 + rand() % 3 * 30;
		float x1 = right_edge + jump_distance;
		float x2 = x1 + platformLength;
		{
			CGPolygon next_platform = make_block(x1, -50, x2, height);
			[listener addedPlatform:next_platform];
			[self addWall:next_platform];
		}

		if (rand() % 10 < 5) {
			float tall_building_near_edge = x2 + 30;
			float tall_building_far_edge = tall_building_near_edge + [self nextPlatformLength];
			CGPolygon tall_building = make_block(tall_building_near_edge, -50, tall_building_far_edge, height + 200);
			[listener addedPlatform:tall_building];
			[self addWall:tall_building];
			
			// fire escape
			[self addWall:make_block(x2 - 100, height + 100, x2 - 80, height + 300)];

			float short_building_near_edge = tall_building_far_edge + 30;
			CGPolygon short_building = make_block(short_building_near_edge, -50, short_building_near_edge + [self nextPlatformLength], height);
			[listener addedPlatform:short_building];
			[self addWall:short_building];
		} else if (rand() % 10 < 5) {
			float building_height = 500;
			float tall_building_near_edge = x2 + 30;
			float tall_building_far_edge = tall_building_near_edge + [self nextPlatformLength];
			CGPolygon tall_building = make_block(tall_building_near_edge, -50, tall_building_far_edge, height + building_height);
			[listener addedPlatform:tall_building];
			[self addWall:tall_building];

			// fire escape
			int gap = 100;
			[self addWall:make_block(x2 - 100, height + gap, x2 - 80, height - gap + building_height)];

			CGPolygon above_building = make_block(x2 - 100 - [self nextPlatformLength], height - gap + building_height - 100, x2 - 100, height - gap + building_height);
			[listener addedPlatform:above_building];
			[self addWall:above_building];
		}
//	Add the occasional slope.
//		} else if (rand() % 10 < 5) {
//		[self addWall:polygon_from(3, cgp(x1, height), cgp(x2, height), cgp((x2 + x1)/2, height + 40))];
//		}
	}

	int previousWallCount = [walls count] - 1;
	while ([walls count] > previousWallCount) {
		CGPolygon wall;
		NSValue *wallObject = [walls objectAtIndex:0];
		[wallObject getValue:&wall];
		bool remove = true;
		for (int i = 0; i < wall.count; i++) {
			if (wall.points[i].x > (point.x - 2000)) {
				remove = false;
			}
		}
		if (remove) {
			[walls removeObjectAtIndex:0];
			free_polygon(wall);
		}

		previousWallCount = [walls count];
	}
}

- (float)nextJumpDistance {
	return min_jump_distance + (rand() % (int) (max_jump_distance - min_jump_distance));
}

- (float)nextPlatformLength {
	return min_platform_length + (rand() % (int) (max_platform_length - min_platform_length));
}

@end