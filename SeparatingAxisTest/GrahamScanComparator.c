//
//  GrahamScanComparator.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/30/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "GrahamScanComparator.h"


int cmptr(void *_min, const void *_a, const void *_b) {
    const Vector *min = _min;
    const Vector *a = _a;
    const Vector *b = _b;
    
    Vector minToA = vector_subtract(*a, *min);
    Vector minToB = vector_subtract(*b, *min);
    
    Vector unitX = vector_from(1, 0);
    float dotUnitXWithA = vector_dot(unitX, vector_normal(minToA));
    float dotUnitXWithB = vector_dot(unitX, vector_normal(minToB));
    
    return 0;
}


