//
//  GrahamScanComparator.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/30/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "GrahamScanComparatorTests.h"

#include "CGPoint_ops.h"
#include "GrahamScanComparator.h"

@implementation GrahamScanComparatorTests

-(void) testSortingVectorsWithFanciness {
    CGPoint vector = cgp_from(0, 0);
    
    CGPoint vectors[] = {
        cgp_from(1, 1), cgp_from(-1, 1), cgp_from(0, 1)
    };
    qsort_r(vectors, 3, sizeof(CGPoint), &vector, graham_comparator);

    STAssertEquals(vectors[1].y, 1.0f, @"");
    STAssertEquals(vectors[1].x, 0.0f, @"");
}


@end
