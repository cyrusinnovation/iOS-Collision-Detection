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
	float min_platform_length;
	float max_platform_length;

	float min_jump_distance;
	float max_jump_distance;

	Platform *last_platform;
	GenerateDirection generate_direction;
	NSObject <NewPlatformListener> *listener;

	float next_trigger_height;
	float height_between_levels;
	float platform_depth;
	float fire_escape_clearance;
	float tall_building_height;
	float gap_before_tall_building;
	float fire_escape_offset;
	float fire_escape_width;
}

@synthesize walls;
@synthesize listener;
@synthesize next_trigger_height;

- (id)init {
	if (self = [super init]) {
		walls = [[NSMutableArray alloc] init];

		min_platform_length = 400;
		max_platform_length = 700;

		min_jump_distance = 100;
		max_jump_distance = 160;

		height_between_levels = 500;

		generate_direction = Right;
		platform_depth = 100;

		gap_before_tall_building = 30;
		fire_escape_clearance = 100;
		tall_building_height = 200;

		fire_escape_offset = 80;
		fire_escape_width = 20;

		listener = [NullStageListener instance];
	}
	return self;
}

- (void)prime {
	[walls removeAllObjects];

	[self addPlatform:[Platform from:make_block(-200, -platform_depth, 1000, 0)]];
	[self generateNextLevel];
	[self generateNextLevel];

	next_trigger_height = height_between_levels;
}

- (void)addPlatform:(Platform *)platform {
	[walls addObject:platform];
	last_platform = platform;
}

- (void)dealloc {
	[walls release];
	[super dealloc];
}

- (void)generateNextLevel {
	int platformCount = rand() % 8 + 1;

	for (int i = 0; i < platformCount; i++) {
		if (rand() % 10 < 8) {
			[self addAPlatform];
		} else {
			[self addAWallJump];
		}
	}

	[self addJumpToNextLevel];
}

- (void)addAPlatform {
	float jump_distance = [self nextJumpDistance];
	float platformLength = [self nextPlatformLength];

	float top = last_platform.bottom + platform_depth + [self nextPlatformHeight];

	Platform *platform = [self makeNewPlatformAfter:last_platform space_between:jump_distance width:platformLength top:top bottom:last_platform.bottom];
	[listener addedPlatform:platform];
}

- (void)addAWallJump {
	Platform *jumpPlatform = last_platform;

	Platform *tall_building = [self makeNewPlatformAfter:jumpPlatform space_between:gap_before_tall_building width:[self nextPlatformLength] top:jumpPlatform.top + tall_building_height bottom:jumpPlatform.bottom];
	
	[self makeFireEscapeNextTo:tall_building bottom:jumpPlatform.top + fire_escape_clearance top:jumpPlatform.top + fire_escape_clearance + tall_building_height];

	[self makeNewPlatformAfter:tall_building space_between:gap_before_tall_building width:[self nextPlatformLength] top:jumpPlatform.top bottom:jumpPlatform.bottom];
}

- (void)addJumpToNextLevel {
	float next_level_bottom = last_platform.bottom + height_between_levels;
	float next_level_top = next_level_bottom + platform_depth;

	Platform *jumpPlatform = last_platform;
	Platform *tall_building = [self makeNewPlatformAfter:jumpPlatform space_between:gap_before_tall_building width:[self nextPlatformLength] top:next_level_bottom + height_between_levels bottom:jumpPlatform.bottom];
	
	Platform *fire_escape = [self makeFireEscapeNextTo:tall_building bottom:jumpPlatform.top + fire_escape_clearance  top:next_level_top];

	generate_direction = !generate_direction;
	[self makeNewPlatformAfter:fire_escape space_between:0 width:[self nextPlatformLength] top:next_level_top bottom:next_level_bottom];
}

- (Platform *)makeFireEscapeNextTo:(Platform *)platform bottom:(float)bottom top:(float)top {
	Platform *fire_escape;
	if (generate_direction == Right) {
		fire_escape = [Platform from:make_block(platform.left - (fire_escape_offset + fire_escape_width), bottom, platform.left - fire_escape_offset, top)];
	} else {
		fire_escape = [Platform from:make_block(platform.right + fire_escape_offset, bottom, platform.right + (fire_escape_offset + fire_escape_width), top)];
	}
	[self addPlatform:fire_escape];
	return fire_escape;
}

- (Platform *)makeNewPlatformAfter:(Platform *)last space_between:(float)space_between width:(float)width top:(float)top bottom:(float)bottom {
	float left_edge = last.right + space_between;
	float right_edge = left_edge + width;
	if (generate_direction == Left) {
		right_edge = last.left - space_between;
		left_edge = right_edge - width;
	}

	Platform *new_platform = [Platform from:make_block(left_edge, bottom, right_edge, top)];
	[self addPlatform:new_platform];
	return new_platform;
}

- (void)generateAround:(Guy *)guy {
	if (guy.location.y > next_trigger_height) {
		[self generateNextLevel];
		next_trigger_height += height_between_levels;
	}
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