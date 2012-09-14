//
//  State.m
//  EggDrop
//
//  Created by Jason Reid on 9/14/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Score.h"

@implementation Score

-(NSInteger) value {
    return value;
}

-(id) init {
    observers = [[NSMutableSet alloc] initWithCapacity:4];
    value = 0;
    return self;
}

-(void) adjustBy:(NSInteger)d {
    value += d;
    for(id ob in observers) {
        [ob scoreChanged:value];
    }
}

- (void)addObserver:(id <ScoreObserver>)observer {
    [observers addObject:observer];
    [observer scoreChanged:value];
}

- (void)dealloc {
    [observers release];
    [super dealloc];
}


@end
