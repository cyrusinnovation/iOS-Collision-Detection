//
//  GrahamScanComparator.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/30/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#ifndef SeparatingAxisTest_GrahamScanComparator_h
#define SeparatingAxisTest_GrahamScanComparator_h

#include "CGPoint_ops.h"
#include "Polygon.h"

int graham_comparator(void *_min, void const *_a, void const *_b);
void graham_filter_colinears(CGPolygon *poly);

#endif