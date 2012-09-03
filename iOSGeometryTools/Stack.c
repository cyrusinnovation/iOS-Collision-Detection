//
//  Stack.c
//
//
//  Created by Najati Imam on 8/25/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>

#include "Stack.h"

Stack new_stack(int capacity) {
    Stack ret;
    ret.capacity = capacity;
    ret.count = 0;
    ret.points = malloc(capacity*sizeof(CGPoint));
    return ret;
}

void s_push(Stack *stack, CGPoint p) {
    if (stack->count >= stack->capacity) return;
    
    stack->points[stack->count].x = p.x;
    stack->points[stack->count].y = p.y;
    
    stack->count += 1;
}

CGPoint s_pop(Stack *stack) {
    // TODO - maybe, this kinda sucks
    if (stack->count == 0) return CGPointMake(FLT_MIN, FLT_MIN);
    stack->count -= 1;
    return stack->points[stack->count];
}
