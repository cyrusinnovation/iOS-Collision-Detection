//
//  GrahamScanComparator.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/30/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "GrahamScanComparator.h"

int graham_comparator(void *_min, void const *_a, void const *_b) {
    CGPoint *min = _min;
    const CGPoint *a = _a;
    const CGPoint *b = _b;
    
    CGPoint minToA = cgp_subtract(*a, *min);
    CGPoint minToB = cgp_subtract(*b, *min);
    
    CGPoint unitX = cgp_from(1, 0);
    float dotUnitXWithA = cgp_dot(unitX, cgp_normal(minToA));
    float dotUnitXWithB = cgp_dot(unitX, cgp_normal(minToB));
    
    if (dotUnitXWithA < dotUnitXWithB) return -1;
    if (dotUnitXWithA > dotUnitXWithB) return 1;
    
    return 0;
}


