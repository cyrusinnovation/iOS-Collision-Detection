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
	[view setFlipX:true];
}

- (void)runningRight {
	[view setFlipX:false];
}

- (void)wallJumping {
	[view startAnimation:viewFactory.jumpUpAnimation];
}

- (void)groundJumping {
	[view startAnimation:viewFactory.jumpUpAnimation];
}

- (void)falling {
	[view startAnimation:viewFactory.jumpDownAnimation];
}

- (void)running {
	[view playAnimations:viewFactory.landAnimation andThen:viewFactory.runningAnimation];
}

- (void)dying {
}

- (void)attacking {
}


@end