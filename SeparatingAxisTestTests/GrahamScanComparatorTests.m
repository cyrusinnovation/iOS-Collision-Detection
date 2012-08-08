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

-(void) testEquals {
    CGPoint min = cgp_from(0, 0);
    CGPoint a = cgp_from(1, 1);
    CGPoint b = cgp_from(1, 1);
    STAssertEquals(0, graham_comparator(&min, &a, &b), @"");
}

-(void) testColinearLessThan {
    {
        CGPoint min = cgp_from(0, 0);
        CGPoint a = cgp_from(1, 1);
        CGPoint b = cgp_from(2, 2);
        STAssertEquals(graham_comparator(&min, &a, &b), -1, @"");
    }

    {
        CGPoint min = cgp_from(0, 0);
        CGPoint a = cgp_from(1, 1);
        CGPoint b = cgp_from(3, 3);
        STAssertEquals(graham_comparator(&min, &a, &b), -1, @"");
    }
    
    {
        CGPoint min = cgp_from(0, 0);
        CGPoint a = cgp_from(3, 3);
        CGPoint b = cgp_from(1, 1);
        STAssertEquals(graham_comparator(&min, &a, &b), 1, @"");
    }
    
}

-(void) testColinearGreaterThan {
    CGPoint min = cgp_from(0, 0);
    CGPoint a = cgp_from(2, 2);
    CGPoint b = cgp_from(1, 1);
    STAssertEquals(1, graham_comparator(&min, &a, &b), @"");
}

-(void) assert: (CGPoint) p is: (float) x and: (float) y line:(int) line {
    NSString *errar = [NSString stringWithFormat: @"Expected [%f, %f], actual [%f, %f]", x, y, p.x, p.y];
    
    if (p.x == x && p.y == y)
        return;
    else {
        // This is kinda shitty.
        [self failWithException:[NSException 
                                 failureInCondition: @"Point equality"
                                 isTrue:true 
                                 inFile:[NSString stringWithUTF8String:__FILE__] 
                                 atLine:line 
                                 withDescription:errar]];
    }
}

-(void) testSquare {
    CGPoint vector = cgp_from(0, 0);
    
    CGPoint vectors[] = {
        cgp_from(0, 2), cgp_from(2, 2), cgp_from(0, 0), cgp_from(2, 0)
    };
    qsort_r(vectors, 4, sizeof(CGPoint), &vector, graham_comparator);
    
    [self assert: vectors[0] is: 0 and: 0 line:__LINE__];
    [self assert: vectors[1] is: 2 and: 0 line:__LINE__];
    [self assert: vectors[2] is: 2 and: 2 line:__LINE__];
    [self assert: vectors[3] is: 0 and: 2 line:__LINE__];
}

-(void) testColinearsAreNearestFirst {
    CGPoint vector = cgp_from(0, 0);
    
    CGPoint vectors[] = {
        cgp_from(0, 1), cgp_from(0, 2), cgp_from(2, 2), cgp_from(0, 0), cgp_from(1, 1), cgp_from(2, 0)
    };
    qsort_r(vectors, 6, sizeof(CGPoint), &vector, graham_comparator);
    
    [self assert: vectors[0] is: 0 and: 0 line:__LINE__];
    [self assert: vectors[1] is: 2 and: 0 line:__LINE__];
    [self assert: vectors[2] is: 1 and: 1 line:__LINE__];
    [self assert: vectors[3] is: 2 and: 2 line:__LINE__];
    [self assert: vectors[4] is: 0 and: 1 line:__LINE__];
    [self assert: vectors[5] is: 0 and: 2 line:__LINE__];
}

-(void) testColinearSortingAndFiltering {
    CGPoint vector = cgp_from(0, 0);
    
    CGPoint vectors[] = {
        cgp_from(0, 0),
        cgp_from(3, 0),
        cgp_from(1, 1),
        cgp_from(2, 2),
        cgp_from(3, 3), 
        cgp_from(0, 3), 
        cgp_from(-1, 2),
        cgp_from(-1, 1)
    };
    qsort_r(vectors, 8, sizeof(CGPoint), &vector, graham_comparator);
    
    [self assert: vectors[0] is: 0 and: 0 line:__LINE__];
    [self assert: vectors[1] is: 3 and: 0 line:__LINE__];
    [self assert: vectors[2] is: 1 and: 1 line:__LINE__];
    [self assert: vectors[3] is: 2 and: 2 line:__LINE__];
    [self assert: vectors[4] is: 3 and: 3 line:__LINE__];
    [self assert: vectors[5] is: 0 and: 3 line:__LINE__];
    [self assert: vectors[6] is: -1 and: 2 line:__LINE__];
    [self assert: vectors[7] is: -1 and: 1 line:__LINE__];
    
    CGPolygon poly = { vectors, 8 };
    graham_filter_colinears(&poly);
    
    STAssertEquals(6, poly.point_count, @"");
    [self assert: vectors[0] is: 0 and: 0 line:__LINE__];
    [self assert: vectors[1] is: 3 and: 0 line:__LINE__];
    [self assert: vectors[2] is: 3 and: 3 line:__LINE__];
    [self assert: vectors[3] is: 0 and: 3 line:__LINE__];
    [self assert: vectors[4] is: -1 and: 2 line:__LINE__];
    [self assert: vectors[5] is: -1 and: 1 line:__LINE__];
}

-(void) testColinearFilteringSimple {
    CGPoint vector = cgp_from(0, 0);
    
    CGPoint vectors[] = {
        cgp_from(0, 0),
        cgp_from(2, 0),
        cgp_from(1, 1),
        cgp_from(2, 2),
        cgp_from(0, 2)
    };
    qsort_r(vectors, 5, sizeof(CGPoint), &vector, graham_comparator);
    CGPolygon poly = { vectors, 5 };
    graham_filter_colinears(&poly);
    
    STAssertEquals(4, poly.point_count, @"");
    [self assert: vectors[0] is: 0 and: 0 line:__LINE__];
    [self assert: vectors[1] is: 2 and: 0 line:__LINE__];
    [self assert: vectors[2] is: 2 and: 2 line:__LINE__];
    [self assert: vectors[3] is: 0 and: 2 line:__LINE__];
}

@end
