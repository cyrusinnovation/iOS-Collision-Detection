//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PlacingModeMenu.h"

@implementation PlacingModeMenu

-(id) init:(BouncingEggLayer *) bouncingEggLayer {
	CCMenuItemFont *dropEgg =
			[CCMenuItemSprite
					itemWithNormalSprite:[CCSprite spriteWithFile:@"drop.png"]
								selectedSprite:[CCSprite spriteWithFile:@"drop.png"]
												target:bouncingEggLayer
											selector:@selector(enterGameStateDropping)
			];
	CCMenuItemFont *resetTrampolines =
			[CCMenuItemSprite
					itemWithNormalSprite:[CCSprite spriteWithFile:@"drop.png"]
								selectedSprite:[CCSprite spriteWithFile:@"drop.png"]
												target:bouncingEggLayer
											selector:@selector(resetTrampolines)
			];

	NSArray *items = [NSArray arrayWithObjects:resetTrampolines, dropEgg, nil];
	if (self = [super initWithArray:items]) {
		[self alignItemsHorizontally];
	}
	return self;
}

@end