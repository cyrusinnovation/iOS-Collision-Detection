//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Levels.h"
#import "Level.h"
#import "CCDirector.h"
#import "CGPoint_ops.h"


@implementation Levels

+ (Level *)level1 {
	CGSize s = [[CCDirector sharedDirector] winSize];
	Level *level = [[Level alloc] init];
	level.initialEggLocation = cgp(s.width / 2, s.height + 100);
	level.nestLocation = cgp(s.width / 4, 60);
	[level addStar:cgp(0.25, 0.75)];
	[level addStar:cgp(0.75, 0.50)];
	[level addStar:cgp(0.35, 0.30)];
	return level;
}
@end