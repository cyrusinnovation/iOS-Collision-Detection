//
//  GrahamScanTests.m
//
//
//  Created by Najati Imam on 8/2/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "GrahamScanTests.h"

#include "GrahamScan.h"
#include "CGPoint_ops.h"

#include "Polygon.h"

@implementation GrahamScanTests

-(void) testIsSegmentInvalid {
    STAssertFalse(gs_is_invalid_segment(cgp(0, 0), cgp(0, 1), cgp(-1, 2)), @"");
    STAssertFalse(gs_is_invalid_segment(cgp(0, 0), cgp(0, 1), cgp(-1, 1)), @"");
    STAssertFalse(gs_is_invalid_segment(cgp(0, 0), cgp(0, 1), cgp(-1, 1.25)), @"");
    STAssertFalse(gs_is_invalid_segment(cgp(0, 0), cgp(0, 1), cgp(-1, 1.5)), @"");
    STAssertFalse(gs_is_invalid_segment(cgp(0, 0), cgp(0, 1), cgp(-1, 1.98)), @"");
    
    STAssertTrue(gs_is_invalid_segment(cgp(0, 0), cgp(0, 1), cgp(0, 2)), @"");
    STAssertTrue(gs_is_invalid_segment(cgp(0, 0), cgp(0, 1), cgp(1, 2)), @"");
    STAssertTrue(gs_is_invalid_segment(cgp(0, 0), cgp(0, 100), cgp(-1, 200)), @"");
}

-(void) testIsLessThanMinimumAngle {
    STAssertFalse(gs_is_less_than_minimum_angle(cgp(0, 0), cgp(0, 1), cgp(1, 1)), @"");
    STAssertFalse(gs_is_less_than_minimum_angle(cgp(0, 0), cgp(0, 1), cgp(-1, 1)), @"");

    STAssertTrue(gs_is_less_than_minimum_angle(cgp(0, 0), cgp(0, 1), cgp(0, 2)), @"");
    STAssertTrue(gs_is_less_than_minimum_angle(cgp(0, 0), cgp(0, 100), cgp(-1, 200)), @"");
}

-(void) testIsStraightOrClockwise {
    STAssertFalse(gs_straight_or_clockwise(cgp(0, 0), cgp(0, 1), cgp(-1, 2)), @"");
    STAssertTrue(gs_straight_or_clockwise(cgp(0, 0), cgp(0, 1), cgp(0, 2)), @"");
    STAssertTrue(gs_straight_or_clockwise(cgp(0, 0), cgp(0, 1), cgp(1, 2)), @"");
    STAssertFalse(gs_straight_or_clockwise(cgp(0, 0), cgp(0, 10), cgp(-1, 20)), @"");
}

-(void) testThatComplexShapeIsNotValid {
    CGPolygon poly = polygon_from(8, 
                                  cgp(0, 0), 
                                  cgp(2, 0), 
                                  cgp(2, 2), 
                                  cgp(1, 2), 
                                  cgp(1, 1), 
                                  cgp(3, 1), 
                                  cgp(3, 3), 
                                  cgp(0, 3));
    
    STAssertFalse(gs_validate(poly), @"");
}

-(void) testThatComplexShapeInReverseOrderIsNotValid {
    CGPolygon poly = polygon_from(8, 
                                  cgp(0, 3),       
                                  cgp(3, 3),
                                  cgp(3, 1),
                                  cgp(1, 1),
                                  cgp(1, 2),
                                  cgp(2, 2),
                                  cgp(2, 0),
                                  cgp(0, 0));
    
    STAssertFalse(gs_validate(poly), @"");
}

-(void) testThatColinearIsNotValid {
    CGPolygon poly = polygon_from(5, 
                                  cgp(0, 0),       
                                  cgp(1, 0),
                                  cgp(1, 1),
                                  cgp(1, 2),
                                  cgp(0, 2));
    
    STAssertFalse(gs_validate(poly), @"");
}

-(void) testThatConcaveIsNotValid {
    CGPolygon poly = polygon_from(5,
                                  cgp(0, 0),       
                                  cgp(1, 0),
                                  cgp(0.5f, 1),
                                  cgp(1, 2),
                                  cgp(0, 2));
    
    STAssertFalse(gs_validate(poly), @"");
}

-(void) testThatBoxIsValid {
    STAssertTrue(gs_validate(make_block(0, 0, 1, 1)), @"");
}


@end
