//
//  GrahamScanComparator.m
//
//
//  Created by Najati Imam on 7/30/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "VectorAssert.h"

#include "GrahamScanComparatorTests.h"

#include "CGPoint_ops.h"
#include "GrahamScanComparator.h"


@implementation GrahamScanComparatorTests

-(void) testSortingVectorsWithFanciness {
    CGPoint vector = cgp(0, 0);
    
    CGPoint vectors[] = {
        cgp(1, 1), cgp(-1, 1), cgp(0, 1)
    };
    qsort_r(vectors, 3, sizeof(CGPoint), &vector, graham_comparator);
    
    STAssertEquals(vectors[1].y, 1.0f, @"");
    STAssertEquals(vectors[1].x, 0.0f, @"");
}

-(void) testEquals {
    CGPoint min = cgp(0, 0);
    CGPoint a = cgp(1, 1);
    CGPoint b = cgp(1, 1);
    STAssertEquals(0, graham_comparator(&min, &a, &b), @"");
}

-(void) testColinearLessThan {
    {
        CGPoint min = cgp(0, 0);
        CGPoint a = cgp(1, 1);
        CGPoint b = cgp(2, 2);
        STAssertEquals(graham_comparator(&min, &a, &b), -1, @"");
    }

    {
        CGPoint min = cgp(0, 0);
        CGPoint a = cgp(1, 1);
        CGPoint b = cgp(3, 3);
        STAssertEquals(graham_comparator(&min, &a, &b), -1, @"");
    }
    
    {
        CGPoint min = cgp(0, 0);
        CGPoint a = cgp(3, 3);
        CGPoint b = cgp(1, 1);
        STAssertEquals(graham_comparator(&min, &a, &b), 1, @"");
    }
    
}

-(void) testColinearGreaterThan {
    CGPoint min = cgp(0, 0);
    CGPoint a = cgp(2, 2);
    CGPoint b = cgp(1, 1);
    STAssertEquals(1, graham_comparator(&min, &a, &b), @"");
}
    
-(void) testSquare {
    CGPoint vector = cgp(0, 0);
    
    CGPoint vectors[] = {
        cgp(0, 2), cgp(2, 2), cgp(0, 0), cgp(2, 0)
    };
    qsort_r(vectors, 4, sizeof(CGPoint), &vector, graham_comparator);
    
    VectorAssertEquals(vectors[0], 0, 0);
    VectorAssertEquals(vectors[1], 2, 0);
    VectorAssertEquals(vectors[2], 2, 2);
    VectorAssertEquals(vectors[3], 0, 2);
}

-(void) testColinearsAreNearestFirst {
    CGPoint vector = cgp(0, 0);
    
    CGPoint vectors[] = {
        cgp(0, 1), cgp(0, 2), cgp(2, 2), cgp(0, 0), cgp(1, 1), cgp(2, 0)
    };
    qsort_r(vectors, 6, sizeof(CGPoint), &vector, graham_comparator);
    
    VectorAssertEquals(vectors[0], 0, 0);
    VectorAssertEquals(vectors[1], 2, 0);
    VectorAssertEquals(vectors[2], 1, 1);
    VectorAssertEquals(vectors[3], 2, 2);
    VectorAssertEquals(vectors[4], 0, 1);
    VectorAssertEquals(vectors[5], 0, 2);
}

-(void) testColinearSortingAndFiltering {
    CGPoint vector = cgp(0, 0);
    
    CGPoint vectors[] = {
        cgp(0, 0),
        cgp(3, 0),
        cgp(1, 1),
        cgp(2, 2),
        cgp(3, 3), 
        cgp(0, 3), 
        cgp(-1, 2),
        cgp(-1, 1)
    };
    qsort_r(vectors, 8, sizeof(CGPoint), &vector, graham_comparator);
    
    VectorAssertEquals(vectors[0], 0, 0);
    VectorAssertEquals(vectors[1], 3, 0);
    VectorAssertEquals(vectors[2], 1, 1);
    VectorAssertEquals(vectors[3], 2, 2);
    VectorAssertEquals(vectors[4], 3, 3);
    VectorAssertEquals(vectors[5], 0, 3);
    VectorAssertEquals(vectors[6], -1, 2);
    VectorAssertEquals(vectors[7], -1, 1);
    
    CGPolygon poly = { vectors, 8 };
    graham_filter_colinears(&poly);
    
    STAssertEquals(6, poly.count, @"");
    VectorAssertEquals(vectors[0], 0, 0);
    VectorAssertEquals(vectors[1], 3, 0);
    VectorAssertEquals(vectors[2], 3, 3);
    VectorAssertEquals(vectors[3], 0, 3);
    VectorAssertEquals(vectors[4], -1, 2);
    VectorAssertEquals(vectors[5], -1, 1);
}

-(void) testColinearFilteringSimple {
    CGPoint vector = cgp(0, 0);
    
    CGPoint vectors[] = {
        cgp(0, 0),
        cgp(2, 0),
        cgp(1, 1),
        cgp(2, 2),
        cgp(0, 2)
    };
    qsort_r(vectors, 5, sizeof(CGPoint), &vector, graham_comparator);
    CGPolygon poly = { vectors, 5 };
    graham_filter_colinears(&poly);
    
    STAssertEquals(4, poly.count, @"");
    VectorAssertEquals(vectors[0], 0, 0);
    VectorAssertEquals(vectors[1], 2, 0);
    VectorAssertEquals(vectors[2], 2, 2);
    VectorAssertEquals(vectors[3], 0, 2);
}

@end
