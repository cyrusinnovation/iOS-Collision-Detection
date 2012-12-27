//
// by najati 
// copyright Cyrus Innovation
//


#import "ProxyCollection.h"

@implementation ProxyCollection {
	NSMutableArray *targets;
}

- (id)init {
	self = [super init];
	if (!self) return self;

	targets = [[NSMutableArray alloc] init];

	return self;
}

- (void)add:(id)object {
	[targets addObject:object];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	for (id target in targets) {
		if ([target respondsToSelector:anInvocation.selector]) {
			[anInvocation invokeWithTarget:target];
		}
	}
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	for (id target in targets) {
		if ([target respondsToSelector:aSelector]) {
			return true;
		}
	}
	return false;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	return [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
}

@end