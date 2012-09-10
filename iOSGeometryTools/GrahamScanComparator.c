//
//  GrahamScanComparator.m
//
//  Created by Najati Imam on 7/30/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "GrahamScanComparator.h"

#include "CGPoint_ops.h"

#include "GrahamScan.h"

#define COLINEAR_EPSILON 0.000001

int graham_comparator(void *_min, void const *_a, void const *_b) {
    CGPoint *min = _min;
    const CGPoint *a = _a;
    const CGPoint *b = _b;
    
    if (a->x == min->x && a->y == min->y) return -1;
    if (b->x == min->x && b->y == min->y) return 1;
    if (a->x == b->x && a->y == b->y) return 0;
    
    CGPoint minToA = cgp_subtract(*a, *min);
    CGPoint minToB = cgp_subtract(*b, *min);
    
    CGPoint unitX = cgp(1, 0);
    float dotUnitXWithA = cgp_dot(unitX, cgp_normal(minToA));
    float dotUnitXWithB = cgp_dot(unitX, cgp_normal(minToB));
    
    if (dotUnitXWithA - dotUnitXWithB > COLINEAR_EPSILON) return -1;
    if (dotUnitXWithA - dotUnitXWithB < -COLINEAR_EPSILON) return 1;
    
    float lengthToA = cgp_length_squared(minToA);
    float lengthToB = cgp_length_squared(minToB);
    if (lengthToA < lengthToB) return -1;
    if (lengthToA > lengthToB) return 1;
    
    return 0;
}

void graham_filter_colinears(CGPolygon *poly) {
    int filtered_count = 1;
    
    CGPoint min = poly->points[0];
    for (int i = 1; i < poly->count; i++) {
        CGPoint a = poly->points[i];
        CGPoint b = poly->points[filtered_count-1];
        if (gs_are_points_colinear(min, a, b)) {
            poly->points[filtered_count-1] = poly->points[i];
        } else {
            poly->points[filtered_count] = poly->points[i];
            filtered_count++;
        }
    }
    
    poly->count = filtered_count;
}

