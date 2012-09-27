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
}

@synthesize walls;
@synthesize listener;

- (id)init {
	if (self = [super init]) {
		walls = [[NSMutableArray alloc] init];
		right_edge = 0;

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

	last_platform = [Platform from:make_block(-200, -300, 1000, 50)];
	[self addPlatform:last_platform];
	[self generateNextLevel];
}

- (void)addPlatform:(Platform *)wall {
	[walls addObject:wall];

	if (wall.right > right_edge) {
		right_edge = wall.right;
	}
}

- (void)dealloc {
	[walls release];
	[super dealloc];
}

-(void) generateNextLevel {
	int platformCount = rand()%10;

	for (int i = 0; i < platformCount; i++) {
		float jump_distance = [self nextJumpDistance];
		float platformLength = [self nextPlatformLength];

		float height = last_platform.top + [self nextPlatformHeight];

		float x1 = right_edge + jump_distance;
		float x2 = x1 + platformLength;

		Platform *platform = [Platform from:make_block(x1, -50, x2, height)];
		[listener addedPlatform:platform];
		[self addPlatform:platform];
	}
}

- (void)generateAround:(Guy *)guy  {
//	CGPoint location = guy.location;
//
//	location = cgp_add(location, cgp(max_jump_distance + max_platform_length, 0));
//	if (location.x > right_edge) {
//		if (rand() % 10 < 5) {
//			float tall_building_near_edge = x2 + 30;
//			float tall_building_far_edge = tall_building_near_edge + [self nextPlatformLength];
//			CGPolygon tall_building = make_block(tall_building_near_edge, -50, tall_building_far_edge, height + 200);
//			[listener addedPlatform:tall_building];
//			[self addPlatform:[Platform from:tall_building]];
//
//			// fire escape
//			[self addPlatform:[Platform from:make_block(x2 - 100, height + 100, x2 - 80, height + 300)]];
//
//			float short_building_near_edge = tall_building_far_edge + 30;
//			CGPolygon short_building = make_block(short_building_near_edge, -50, short_building_near_edge + [self nextPlatformLength], height);
//			[listener addedPlatform:short_building];
//			[self addPlatform:[Platform from:short_building]];
//		} else if (rand() % 10 < 5) {
//			float building_height = 500;
//			float tall_building_near_edge = x2 + 30;
//			float tall_building_far_edge = tall_building_near_edge + [self nextPlatformLength];
//			CGPolygon tall_building = make_block(tall_building_near_edge, -50, tall_building_far_edge, height + building_height);
//			[listener addedPlatform:tall_building];
//			[self addPlatform:[Platform from:tall_building]];
//
//			// fire escape
//			int gap = 100;
//			[self addPlatform:[Platform from:make_block(x2 - 100, height + gap, x2 - 80, height - gap + building_height)]];
//
//			CGPolygon above_building = make_block(x2 - 100 - [self nextPlatformLength], height - gap + building_height - 100, x2 - 100, height - gap + building_height);
//			[listener addedPlatform:above_building];
//			[self addPlatform:[Platform from:above_building]];
//		}
//	}
//
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