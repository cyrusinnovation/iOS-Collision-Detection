//
// Created by najati on 9/24/12.
//

#import "Stage.h"
#import "Guy.h"
#import "Platform.h"
#import "NullStageListener.h"

// TODO hahah fix this
#define GenerateDirection bool
#define Left true
#define Right false

@implementation Stage {
	NSMutableArray *walls;
	float right_edge;
	float min_platform_length;
	float max_platform_length;

	float min_jump_distance;
	float max_jump_distance;

	Platform *last_platform;
	GenerateDirection generate_direction;
	NSObject <NewPlatformListener> *listener;
	int base_height;
}

@synthesize walls;
@synthesize listener;
@synthesize base_height;


- (id)init {
	if (self = [super init]) {
		walls = [[NSMutableArray alloc] init];
		right_edge = 0;
		base_height = 0;

		min_platform_length = 400;
		max_platform_length = 700;

		min_jump_distance = 100;
		max_jump_distance = 160;

		generate_direction = Right;

		listener = [NullStageListener instance];
	}
	return self;
}

- (void)prime {
	[walls removeAllObjects];

	last_platform = [Platform from:make_block(-200, -300, 1000, base_height)];
	[self addPlatform:last_platform];
	[self generateNextLevel];
	[self generateNextLevel];
}

- (void)addPlatform:(Platform *)wall {
	[walls addObject:wall];

	if (wall.right > right_edge) {
		right_edge = wall.right;
	}

	last_platform = wall;
}

- (void)dealloc {
	[walls release];
	[super dealloc];
}

- (void)generateNextLevel {
	int platformCount = rand() % 10;

	for (int i = 0; i < platformCount; i++) {
		if (rand() % 10 < 8) {
			[self addAPlatform];
		} else {
			[self addAWallJump];
		}
	}

	[self goToTheNextLevel];
}

- (void)addAPlatform {
	float jump_distance = [self nextJumpDistance];
	float platformLength = [self nextPlatformLength];

	float height = base_height + [self nextPlatformHeight];

	float left = last_platform.right + jump_distance;
	float right = left + platformLength;
	if (generate_direction == Left) {
		right = last_platform.left - jump_distance;
		left = right - platformLength;
	}

	Platform *platform = [Platform from:make_block(left, base_height - 100, right, height)];
	[listener addedPlatform:platform];
	[self addPlatform:platform];
}

- (void)addAWallJump {
	Platform *jumpPlatform = last_platform;

	float tall_building_left_edge = last_platform.right + 30;
	float tall_building_right_edge = tall_building_left_edge + [self nextPlatformLength];
	if (generate_direction == Left) {
		tall_building_right_edge = last_platform.left - 30;
		tall_building_left_edge = tall_building_right_edge - [self nextPlatformLength];
	}

	Platform *tall_building = [Platform from:make_block(tall_building_left_edge, last_platform.bottom, tall_building_right_edge, last_platform.top + 200)];
	[listener addedPlatform:tall_building];
	[self addPlatform:tall_building];

	// fire escape
	if (generate_direction == Right) {
		[self addPlatform:[Platform from:make_block(tall_building.left - 100, jumpPlatform.top + 100, tall_building.left - 80, jumpPlatform.top + 300)]];
	} else {
		[self addPlatform:[Platform from:make_block(tall_building.right + 80, jumpPlatform.top + 100, tall_building.right + 100, jumpPlatform.top + 300)]];
	}

	float short_building_left_edge = tall_building.right + 30;
	float short_building_right_edge = short_building_left_edge + [self nextPlatformLength];
	if (generate_direction == Left) {
		short_building_right_edge = tall_building.left - 30;
		short_building_left_edge = short_building_right_edge - [self nextPlatformLength];
	}
	Platform *short_building = [Platform from:make_block(short_building_left_edge, jumpPlatform.bottom, short_building_right_edge, jumpPlatform.top)];
	[listener addedPlatform:short_building];
	[self addPlatform:short_building];
}

- (void)goToTheNextLevel {
	float buildingHeight = 500;
	float next_base_height = base_height + buildingHeight;

	Platform *jumpPlatform = last_platform;

	float tall_building_near_edge = last_platform.right + 30;
	float tall_building_far_edge = tall_building_near_edge + [self nextPlatformLength];
	Platform *tall_building = [Platform from:make_block(tall_building_near_edge, last_platform.bottom, tall_building_far_edge, next_base_height + 200)];
	[listener addedPlatform:tall_building];
	[self addPlatform:tall_building];

	// fire escape
	Platform *fire_escape = [Platform from:make_block(tall_building.left - 100, jumpPlatform.top + 100, tall_building.left - 80, next_base_height)];
	[self addPlatform:fire_escape];

	Platform *start_of_next_level = [Platform from:make_block(fire_escape.left - [self nextPlatformLength], next_base_height - 100, fire_escape.left, next_base_height)];
	[listener addedPlatform:start_of_next_level];
	[self addPlatform:start_of_next_level];

	base_height = next_base_height;
	generate_direction = !generate_direction;
}

- (void)generateAround:(Guy *)guy {
//	int previousPlatformCount = [walls count] - 1;
//	while ([walls count] > previousPlatformCount) {
//		Platform *wall = [walls objectAtIndex:0];
//		bool remove = true;
//		for (int i = 0; i < wall.polygon.count; i++) {
//			if (wall.polygon.points[i].x > (location.x - 2000)) {
//				remove = false;
//			}
//		}
//		if (remove) {
//			[walls removeObjectAtIndex:0];
//			[wall release];
//		}
//
//		previousPlatformCount = [walls count];
//	}
}

- (float)nextJumpDistance {
	return min_jump_distance + (rand() % (int) (max_jump_distance - min_jump_distance));
}

- (float)nextPlatformLength {
	return min_platform_length + (rand() % (int) (max_platform_length - min_platform_length));
}

- (int)nextPlatformHeight {
	return rand() % 3 * 25;
}

@end