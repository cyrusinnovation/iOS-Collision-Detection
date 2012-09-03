//
//  Range.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "Range.h"

#include <stdbool.h>
#include <math.h>

Range range_from(float min, float max) {
    Range r;
    r.min = min;
    r.max = max;
    return r;
}

Overlap create_overlap(Range a, Range b) {
    bool overlaps = !((a.max < b.min) || (b.max < a.min));
    
    Overlap overlap;
    
    if (!overlaps) {
        overlap.overlaps = false;
        overlap.correction = 0;
    } else {
        float left = -(a.max - b.min);
        float right = b.max - a.min;
        float correction = fabsf(left) < fabsf(right) ? left : right;
        
        overlap.overlaps = true;
        overlap.correction = correction;
    }
    
    return overlap;
}
