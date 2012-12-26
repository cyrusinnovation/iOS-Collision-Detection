//
// by najati 
// copyright Cyrus Innovation
//


#import "CurrentSceneListener.h"
#import "ActorView.h"
#import "ViewFactory.h"
#import "ElementViewMap.h"
#import "BadGuySound.h"
#import "RunningLayer.h"
#import "AudioPlayer.h"

@implementation CurrentSceneListener {
	ElementViewMap *elementViews;
	
	BadGuySound *badGuySound;
	ViewFactory *viewFactory;
	RunningLayer *layer;
}

-(id) init:(RunningLayer *) _layer and:(ViewFactory *)_viewFactory and:(AudioPlayer *)audio {
	self = [super init];
	if (!self) return self;

	layer = _layer;
	viewFactory = _viewFactory;

	elementViews = [[ElementViewMap alloc] init];
	badGuySound = [[BadGuySound alloc] init:audio];
	
	return self;
}

- (void)elementEnteredView:(id <BoundedPolygon>)platform {
	ActorView *view;
	if ([platform isKindOfClass:[Platform class]]) {
		view = [viewFactory createPlatformView:(Platform *) platform parent:layer];
	} else if ([platform isKindOfClass:[BadGuy class]]) {
		BadGuy *badGuy = (BadGuy *) platform;
		view = [viewFactory createBadGuyView:badGuy];
		badGuy.observer = badGuySound;
	} else if ([platform isKindOfClass:[MeleeAttack class]]) {
		view = [viewFactory createMeleeAttackView:(MeleeAttack *) platform];
	}

	if (!view) return;

	[layer addChild:view];
	[elementViews add:view of:platform];
}

- (void)elementLeftView:(id <BoundedPolygon>)platform {
	BOOL isElementOfKnownClass = [platform isKindOfClass:[Platform class]] ||
			[platform isKindOfClass:[BadGuy class]] ||
			[platform isKindOfClass:[MeleeAttack class]];
	if (!isElementOfKnownClass)
		return;

	[layer removeChild:[elementViews removeViewFor:platform] cleanup:true];
}

@end