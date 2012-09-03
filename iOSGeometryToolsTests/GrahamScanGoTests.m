//
//  GrahamScanGoTests.m
//
//
//  Created by Najati Imam on 8/25/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "GrahamScanGoTests.h"

#include "Polygon.h"

#include "GrahamScan.h"

#include "VectorAssert.h"

@implementation GrahamScanGoTests

-(void) testABoxIsABox {
    CGPolygon block = make_block(0, 0, 1, 1);
    STAssertTrue(gs_validate(block), @"");
    
    block = gs_go(block);
    
    VectorAssertEquals(block.points[0], 0, 0);
    VectorAssertEquals(block.points[1], 1, 0);
    VectorAssertEquals(block.points[2], 1, 1);
    VectorAssertEquals(block.points[3], 0, 1);
    STAssertTrue(gs_validate(block), @"");
}

-(void) testABoxByABox {
    CGPolygon block = polygon_from(8,
                                   cgp_from(0, 0),       
                                   cgp_from(1, 0),
                                   cgp_from(1, 1),
                                   cgp_from(0, 1),
                                   cgp_from(1, 1),       
                                   cgp_from(2, 1),
                                   cgp_from(2, 2),
                                   cgp_from(1, 2));
    
    block = gs_go(block);
    
    VectorAssertEquals(block.points[0], 0, 0);
    VectorAssertEquals(block.points[1], 1, 0);
    VectorAssertEquals(block.points[2], 2, 1);
    VectorAssertEquals(block.points[3], 2, 2);
    VectorAssertEquals(block.points[4], 1, 2);
    VectorAssertEquals(block.points[5], 0, 1);
    STAssertEquals(block.count, 6, @"");
    STAssertTrue(gs_validate(block), @"");
}

-(void) testABoxInABox {
    CGPolygon block = polygon_from(8,
                                   cgp_from(0, 0),       
                                   cgp_from(1, 0),
                                   cgp_from(1, 1),
                                   cgp_from(0, 1),
                                   cgp_from(-1, -1),       
                                   cgp_from(3, -1),
                                   cgp_from(3, 3),
                                   cgp_from(-1, 3));
    
    block = gs_go(block);
    
    VectorAssertEquals(block.points[0], -1, -1);
    VectorAssertEquals(block.points[1], 3, -1);
    VectorAssertEquals(block.points[2], 3, 3);
    VectorAssertEquals(block.points[3], -1, 3);
    STAssertEquals(block.count, 4, @"");
    STAssertTrue(gs_validate(block), @"");
}


@end
