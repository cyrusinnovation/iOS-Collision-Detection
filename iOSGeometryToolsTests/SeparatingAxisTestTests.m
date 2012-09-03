//
//
//
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "SeparatingAxisTestTests.h"
#include <Accelerate/Accelerate.h>

#include "Polygon.h"
#include "CGPoint_ops.h"
#include "Range.h"

#include "SATResult.h"
#include "SeparatingAxisTest.h"

@implementation SeparatingAxisTestTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testBoxCrossBox {
    CGPolygon a = make_block(0, 0, 3, 3);
    CGPolygon b = make_block(-1, 1, 1, 2);
    
    SATResult test = sat_test(a, b);
    STAssertTrue(test.penetrating, @"");
    STAssertEquals(test.penetration.x, 1.0f, @"");
    STAssertEquals(test.penetration.y, 0.0f, @"");
    
    free_polygon(a);
    free_polygon(b);
}

- (void) testEasyBox {
    CGPolygon a = make_block(0.0, 0.0, 1.0, 1.0);
    CGPolygon b = make_block(0.0, 0.0, 1.0, 1.0);
    
    SATResult test = sat_test(a, b);
    STAssertTrue(test.penetrating, 0);
    STAssertEquals(test.penetration.x, 1.0f, @"");
    STAssertEquals(test.penetration.y, 0.0f, @"");
    
    free_polygon(a);
    free_polygon(b);
}

- (void) testBoxInBox {
    CGPolygon a = make_block(0.0, 0.0, 3.0, 3.0);
    CGPolygon b = make_block(1.0, 1.0, 2.0, 2.0);
    
    SATResult test = sat_test(a, b);
    STAssertTrue(test.penetrating, @"");
    STAssertEquals(test.penetration.x, 2.0f, @"");
    STAssertEquals(test.penetration.y, 0.0f, @"");
    
    free_polygon(a);
    free_polygon(b);
}

-(void) testBoxOnSpike {
    CGPolygon a = polygon_from(3, cgp_from(0, -1), 
                                cgp_from(1, 2), 
                                cgp_from(2, -1));
    CGPolygon b = make_block(0, 2, 2, 4);
    
    SATResult test = sat_test(a, b);
    STAssertFalse(test.penetrating, @"");
    
    free_polygon(a);
    free_polygon(b);
}

@end
