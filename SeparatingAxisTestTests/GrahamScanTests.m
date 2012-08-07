//
//  GrahamScanTests.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 8/2/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "GrahamScanTests.h"

#include "GrahamScan.h"
#include "CGPoint_ops.h"

@implementation GrahamScanTests

-(void) testIsSegmentInvalid {
    STAssertFalse(gs_is_invalid_segment(cgp_from(0, 0), cgp_from(0, 1), cgp_from(-1, 2)), @"");
    STAssertFalse(gs_is_invalid_segment(cgp_from(0, 0), cgp_from(0, 1), cgp_from(-1, 1)), @"");
    STAssertFalse(gs_is_invalid_segment(cgp_from(0, 0), cgp_from(0, 1), cgp_from(-1, 1.25)), @"");
    STAssertFalse(gs_is_invalid_segment(cgp_from(0, 0), cgp_from(0, 1), cgp_from(-1, 1.5)), @"");
    STAssertFalse(gs_is_invalid_segment(cgp_from(0, 0), cgp_from(0, 1), cgp_from(-1, 1.98)), @"");
    
    STAssertTrue(gs_is_invalid_segment(cgp_from(0, 0), cgp_from(0, 1), cgp_from(0, 2)), @"");
    STAssertTrue(gs_is_invalid_segment(cgp_from(0, 0), cgp_from(0, 1), cgp_from(1, 2)), @"");
    STAssertTrue(gs_is_invalid_segment(cgp_from(0, 0), cgp_from(0, 100), cgp_from(-1, 200)), @"");
}

-(void) testIsLessThanMinimumAngle {
    STAssertFalse(gs_is_less_than_minimum_angle(cgp_from(0, 0), cgp_from(0, 1), cgp_from(1, 1)), @"");
    STAssertFalse(gs_is_less_than_minimum_angle(cgp_from(0, 0), cgp_from(0, 1), cgp_from(-1, 1)), @"");

    STAssertTrue(gs_is_less_than_minimum_angle(cgp_from(0, 0), cgp_from(0, 1), cgp_from(0, 2)), @"");
    STAssertTrue(gs_is_less_than_minimum_angle(cgp_from(0, 0), cgp_from(0, 100), cgp_from(-1, 200)), @"");
}

-(void) testIsStraightOrClockwise {
    STAssertFalse(gs_straight_or_clockwise(cgp_from(0, 0), cgp_from(0, 1), cgp_from(-1, 2)), @"");
    STAssertTrue(gs_straight_or_clockwise(cgp_from(0, 0), cgp_from(0, 1), cgp_from(0, 2)), @"");
    STAssertTrue(gs_straight_or_clockwise(cgp_from(0, 0), cgp_from(0, 1), cgp_from(1, 2)), @"");
    STAssertFalse(gs_straight_or_clockwise(cgp_from(0, 0), cgp_from(0, 10), cgp_from(-1, 20)), @"");
}

@end
