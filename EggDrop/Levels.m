//
// Created by najati on 9/17/12.
//


#import "Levels.h"
#import "Level.h"
#import "CCDirector.h"
#import "CGPoint_ops.h"


@implementation Levels

+ (Level *)level1 {
	CGSize s = [[CCDirector sharedDirector] winSize];
	Level *level = [[Level alloc] init];
	level.initialEggLocation = cgp(s.width / 2, s.height);
	level.nestLocation = cgp(s.width / 4, 60);
	[level addStar:cgp(0.25, 0.75)];
	[level addStar:cgp(0.75, 0.50)];
	[level addStar:cgp(0.35, 0.30)];
	return level;
}

+ (Level *)level2 {
	CGSize s = [[CCDirector sharedDirector] winSize];
	Level *level = [[Level alloc] init];
	level.initialEggLocation = cgp(s.width * 0.75, s.height);
	level.nestLocation = cgp(s.width / 4, 60);
	[level addStar:cgp(0.75, 0.25)];
	[level addStar:cgp(0.75, 0.50)];
	[level addStar:cgp(0.75, 0.75)];

	[level addWall:CGRectMake(s.width / 2 - 10, s.height - 150, 80, 300)];
//	[level addWall:CGRectMake(100, 100, 20, 200)];

	return level;
}

@end