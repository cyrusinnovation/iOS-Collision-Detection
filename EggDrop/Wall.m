//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import <mm_malloc.h>
#import "Wall.h"
#import "Trampoline.h"
#import "CGPoint_ops.h"


@implementation Wall {
	CGRect rectangle;

	NSMutableArray *trampolines;
}

@synthesize rectangle;

+ (NSMutableArray *)wallsFrom:(NSMutableArray *)array {
	NSMutableArray *walls = [[NSMutableArray alloc] init];
	for (NSValue *value in array) {
		CGRect rectangle;
		[value getValue:&rectangle];
		[walls addObject:[[Wall alloc] init:rectangle]];
	}
	return walls;
}

- (id)init:(CGRect)_rectangle {
	if (self = [super init]) {
		rectangle = _rectangle;
		trampolines = [[NSMutableArray alloc] init];
		CGPoint origin = rectangle.origin;
		CGSize size = rectangle.size;
		float halfWidth = size.width / 2;
		float halfHeight = size.height / 2;

		[trampolines addObject:[[Trampoline alloc]
				initFrom:cgp(origin.x - halfWidth, origin.y - halfHeight)
							to:cgp(origin.x + halfWidth, origin.y - halfHeight)]];
		[trampolines addObject:[[Trampoline alloc]
				initFrom:cgp(origin.x - halfWidth, origin.y + halfHeight)
							to:cgp(origin.x + halfWidth, origin.y + halfHeight)]];
		[trampolines addObject:[[Trampoline alloc]
				initFrom:cgp(origin.x - halfWidth, origin.y - halfHeight)
							to:cgp(origin.x - halfWidth, origin.y + halfHeight)]];
		[trampolines addObject:[[Trampoline alloc]
				initFrom:cgp(origin.x + halfWidth, origin.y - halfHeight)
							to:cgp(origin.x + halfWidth, origin.y + halfHeight)]];

		for (Trampoline *trampoline in trampolines) {
			[trampoline setSpringConstant:1000000 andDamping:600];
		}
	}
	return self;
}

- (void)update:(ccTime)dt egg:(Egg *)egg {
	for (Trampoline *trampoline in trampolines) {
		[trampoline update:dt egg:egg];
	}
}

@end