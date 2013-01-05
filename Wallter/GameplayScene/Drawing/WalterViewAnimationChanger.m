//
// Created by najati on 9/24/12.
//

#import "WalterViewAnimationChanger.h"
#import "ActorView.h"
#import "ViewFactory.h"

@implementation WalterViewAnimationChanger {
	ActorView *view;
	ViewFactory *viewFactory;
}

- (id)init:(ActorView *)_view factory:(ViewFactory *) _viewFactory {
	self = [super init];
	if (!self) return self;

	view = _view;
	viewFactory = _viewFactory;

	return self;
}

- (void)runningLeft {
}

- (void)runningRight {
}

- (void)wallJumping {
	[view startAnimation:viewFactory.jumpUp];
}

- (void)groundJumping {
	[view startAnimation:viewFactory.jumpUp];
}

- (void)falling {
	[view startAnimation:viewFactory.jumpDown];
}

- (void)running {
	[view playAnimationSequence:viewFactory.landThenRun];
}

- (void)dying {
}

- (void)attacking {
}


@end