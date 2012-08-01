//
//  GrahamScanComparator.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/30/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "GrahamScanComparatorTests.h"

#import "Vector.h"
#import "GrahamScanComparator.h"

@implementation GrahamScanComparatorTests

-(void) testSortingVectorsWithFanciness {
    Vector vector = vector_from(0, 0);
    
    Vector vectors[] = {
        vector_from(1, 1), vector_from(-1, 1), vector_from(0, 1)
    };
    qsort_r(vectors, 3, sizeof(Vector), &vector, graham_comparator);

    STAssertEquals(vectors[1].y, 1.0f, @"");
    STAssertEquals(vectors[1].x, 0.0f, @"");
}


@end
