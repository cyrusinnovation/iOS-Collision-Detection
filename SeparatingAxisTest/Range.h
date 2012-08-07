//
//  Range.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#ifndef RANGE_H
#define RANGE_H

#include "Overlap.h"

typedef struct {
    float min;
    float max;
} Range;

Range range_from(float min, float max);

Overlap create_overlap(Range a, Range b);

#endif