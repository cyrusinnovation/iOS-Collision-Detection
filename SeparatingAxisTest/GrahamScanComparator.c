//
//  GrahamScanComparator.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/30/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "GrahamScanComparator.h"

int graham_comparator(void *_min, void const *_a, void const *_b) {
    Vector *min = _min;
    const Vector *a = _a;
    const Vector *b = _b;
    
    Vector minToA = vector_subtract(*a, *min);
    Vector minToB = vector_subtract(*b, *min);
    
    Vector unitX = vector_from(1, 0);
    float dotUnitXWithA = vector_dot(unitX, vector_normal(minToA));
    float dotUnitXWithB = vector_dot(unitX, vector_normal(minToB));
    
    if (dotUnitXWithA < dotUnitXWithB) return -1;
    if (dotUnitXWithA > dotUnitXWithB) return 1;
    
    return 0;
}


