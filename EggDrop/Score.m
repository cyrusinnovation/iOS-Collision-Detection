//
//  State.m
//  EggDrop
//
//  Created by Jason Reid on 9/14/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Score.h"

@interface Score()
-(void) setValue:(NSInteger) newValue;
@end

@implementation Score

-(NSInteger) value {
    return value;
}

- (void)setValue:(NSInteger)newValue {
    value = newValue;
}

-(id) init {
    self.value = 0;
    return self;
}

-(void) adjustBy:(NSInteger)d {
    self.value = self.value + d;
}

- (void)reset {
    self.value = 0;
}

- (void)dealloc {
    [super dealloc];
}

@end
