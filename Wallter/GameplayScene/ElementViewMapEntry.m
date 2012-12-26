//
// by najati 
// copyright Cyrus Innovation
//

#import "ElementViewMapEntry.h"

@implementation ElementViewMapEntry 

@synthesize view;
@synthesize element;
@synthesize next;

+ (ElementViewMapEntry *)view:(ActorView *)view element:(id <BoundedPolygon>)element {
	return [[self alloc] init:view and:element];
}

- (id)init:(ActorView *)_view and:(id <BoundedPolygon>)_element {
	self = [super self];
	if (!self) return self;

	view = _view;
	element = _element;
	next = nil;

	return self;
}

@end