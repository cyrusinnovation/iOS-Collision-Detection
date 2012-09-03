//
//  Stack.h
//
//
//  Created by Najati Imam on 8/25/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#ifndef Stack_h
#define Stack_h

#include "CGPoint_ops.h"

typedef struct Stack {
    CGPoint *points;
    int capacity;
    int count;
} Stack;

Stack new_stack(int capacity);
void s_push(Stack *stack, CGPoint p);
CGPoint s_pop(Stack *stack);

#endif
