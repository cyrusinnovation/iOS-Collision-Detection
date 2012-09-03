//
//  StackTests.m
//
//
//  Created by Najati Imam on 8/25/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "StackTests.h"

#include "Stack.h"

#include "CGPoint_ops.h"

#import "VectorAssert.h"

@implementation StackTests

-(void) testCreatingAndAddingStuffToAStack {
    Stack stack = new_stack(10);
    s_push(&stack, cgp_from(0, 0));
    STAssertEquals(stack.count, 1, @"");
    s_push(&stack, cgp_from(37, 14));
    STAssertEquals(stack.count, 2, @"");
    
    CGPoint act = s_pop(&stack);
    VectorAssertEquals(act, 37, 14);
    act = s_pop(&stack);
    VectorAssertEquals(act, 0, 0);
}

@end
