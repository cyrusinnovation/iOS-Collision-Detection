//
//  LineProjectionTests.m
//  iOSGeometryTools
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "LineProjectionTests.h"

#import "VectorAssert.h"

#include "CGPoint_ops.h"

@implementation LineProjectionTests

-(void) testProjectingPointOnLayingOnLine {
    STAssertEquals(0.0f, cgp_t(cgp(0, 1), cgp(1, 1), cgp(0, 1)), @"");

    STAssertEquals(-0.2f, cgp_t(cgp(2, 3), cgp(12, 8), cgp(0, 2)), @"");
    STAssertEquals(0.0f, cgp_t(cgp(2, 3), cgp(12, 8), cgp(2, 3)), @"");
    STAssertEquals(0.2f, cgp_t(cgp(2, 3), cgp(12, 8), cgp(4, 4)), @"");
    STAssertEquals(0.4f, cgp_t(cgp(2, 3), cgp(12, 8), cgp(6, 5)), @"");
    STAssertEquals(0.6f, cgp_t(cgp(2, 3), cgp(12, 8), cgp(8, 6)), @"");
    STAssertEquals(0.8f, cgp_t(cgp(2, 3), cgp(12, 8), cgp(10, 7)), @"");
    STAssertEquals(1.0f, cgp_t(cgp(2, 3), cgp(12, 8), cgp(12, 8)), @"");
    STAssertEquals(1.2f, cgp_t(cgp(2, 3), cgp(12, 8), cgp(14, 9)), @"");
}

-(void) testProjectionOfPointAboveLine {
    STAssertEquals(-0.25f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(0, 3)), @"");
    STAssertEquals( 0.00f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(1, 4)), @"");
    STAssertEquals( 0.25f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(2, 5)), @"");
    STAssertEquals( 0.50f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(3, 6)), @"");
    STAssertEquals( 0.75f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(4, 7)), @"");
    STAssertEquals( 1.00f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(5, 8)), @"");
    STAssertEquals( 1.25f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(6, 9)), @"");
}

-(void) testProjectionOfPointBelowLine {
    STAssertEquals(-0.25f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(2, 1)), @"");
    STAssertEquals( 0.00f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(3, 2)), @"");
    STAssertEquals( 0.25f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(4, 3)), @"");
    STAssertEquals( 0.50f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(5, 4)), @"");
    STAssertEquals( 0.75f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(6, 5)), @"");
    STAssertEquals( 1.00f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(7, 6)), @"");
    STAssertEquals( 1.25f, cgp_t(cgp(2, 3), cgp(6, 7), cgp(8, 7)), @"");
}

-(void) testProjectLineOnLine {
    VectorAssertWithin(cgp_project(cgp(0, 10), cgp(2, 2)), 0, 2, 0.000001);
    VectorAssertWithin(cgp_project(cgp(0, 1), cgp(2, 2)), 0, 2, 0.000001);
    VectorAssertWithin(cgp_project(cgp(1, 1), cgp(2, 2)), 2, 2, 0.000001);
    VectorAssertWithin(cgp_project(cgp(10, 10), cgp(0, 2)), 1, 1, 0.000001);
}

@end
