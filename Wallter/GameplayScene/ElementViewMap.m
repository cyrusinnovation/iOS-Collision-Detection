//
// by najati 
// copyright Cyrus Innovation
//


#import "ElementViewMap.h"

@implementation ElementViewMap {
	ElementViewMapEntry *first;
	ElementViewMapEntry *last;
}

- (id)init {
	self = [super init];
	if (!self) return self;

	first = nil;
	last = nil;

	return self;
}

- (void)add:(ActorView *)view of:(id <BoundedPolygon>)element {
	ElementViewMapEntry *entry = [ElementViewMapEntry view:view element:element];
	if (!first) {
		first = entry;
		last = entry;
	} else {
		last.next = entry;
		last = entry;
	}
}

- (ActorView *)removeViewFor:(id <BoundedPolygon>)element {
	ElementViewMapEntry *entry = first;
	ElementViewMapEntry *previous = nil;

	while (entry != nil && entry.element != element) {
		previous = entry;
		entry = entry.next;
	}

	if (!entry) return nil;

	if (entry == first) {
		first = entry.next;
	} else {
		previous.next = entry.next;
	}

	return entry.view;
}

@end