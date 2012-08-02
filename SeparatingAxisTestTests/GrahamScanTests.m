//
//  GrahamScanTests.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 8/2/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "GrahamScanTests.h"

#import "GrahamScan.h"
#import "Vector.h"

@implementation GrahamScanTests

-(void) testIsSegmentInvalid {
    STAssertFalse(gs_is_invalid_segment(vector_from(0, 0), vector_from(0, 1), vector_from(-1, 2)), @"");
    STAssertFalse(gs_is_invalid_segment(vector_from(0, 0), vector_from(0, 1), vector_from(-1, 1)), @"");
    STAssertFalse(gs_is_invalid_segment(vector_from(0, 0), vector_from(0, 1), vector_from(-1, 1.25)), @"");
    STAssertFalse(gs_is_invalid_segment(vector_from(0, 0), vector_from(0, 1), vector_from(-1, 1.5)), @"");
    STAssertFalse(gs_is_invalid_segment(vector_from(0, 0), vector_from(0, 1), vector_from(-1, 1.98)), @"");
    
    STAssertTrue(gs_is_invalid_segment(vector_from(0, 0), vector_from(0, 1), vector_from(0, 2)), @"");
    STAssertTrue(gs_is_invalid_segment(vector_from(0, 0), vector_from(0, 1), vector_from(1, 2)), @"");
    STAssertTrue(gs_is_invalid_segment(vector_from(0, 0), vector_from(0, 100), vector_from(-1, 200)), @"");
}

-(void) testIsLessThanMinimumAngle {
    STAssertFalse(gs_is_less_than_minimum_angle(vector_from(0, 0), vector_from(0, 1), vector_from(1, 1)), @"");
    STAssertFalse(gs_is_less_than_minimum_angle(vector_from(0, 0), vector_from(0, 1), vector_from(-1, 1)), @"");

    STAssertTrue(gs_is_less_than_minimum_angle(vector_from(0, 0), vector_from(0, 1), vector_from(0, 2)), @"");
    STAssertTrue(gs_is_less_than_minimum_angle(vector_from(0, 0), vector_from(0, 100), vector_from(-1, 200)), @"");
}

-(void) testIsStraightOrClockwise {
    STAssertFalse(gs_straight_or_clockwise(vector_from(0, 0), vector_from(0, 1), vector_from(-1, 2)), @"");
    STAssertTrue(gs_straight_or_clockwise(vector_from(0, 0), vector_from(0, 1), vector_from(0, 2)), @"");
    STAssertTrue(gs_straight_or_clockwise(vector_from(0, 0), vector_from(0, 1), vector_from(1, 2)), @"");
    STAssertFalse(gs_straight_or_clockwise(vector_from(0, 0), vector_from(0, 10), vector_from(-1, 20)), @"");
}

@end
