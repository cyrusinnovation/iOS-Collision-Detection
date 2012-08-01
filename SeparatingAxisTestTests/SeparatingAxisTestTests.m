//
//  SeparatingAxisTestTests.m
//  SeparatingAxisTestTests
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "SeparatingAxisTestTests.h"
#import <Accelerate/Accelerate.h>

#import "Polygon.h"
#import "Vector.h"
#import "Range.h"

#import "SATResult.h"
#import "SeparatingAxisTest.h"

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
    Polygon a = make_block(0, 0, 3, 3);
    Polygon b = make_block(-1, 1, 1, 2);
    
    SATResult test = sat_test(a, b);
    STAssertTrue(test.penetrating, @"");
    STAssertEquals(test.penetration.x, 1.0f, @"");
    STAssertEquals(test.penetration.y, 0.0f, @"");
    
    free_polygon(a);
    free_polygon(b);
}

- (void) testEasyBox {
    Polygon a = make_block(0.0, 0.0, 1.0, 1.0);
    Polygon b = make_block(0.0, 0.0, 1.0, 1.0);
    
    SATResult test = sat_test(a, b);
    STAssertTrue(test.penetrating, 0);
    STAssertEquals(test.penetration.x, 1.0f, @"");
    STAssertEquals(test.penetration.y, 0.0f, @"");
    
    free_polygon(a);
    free_polygon(b);
}

- (void) testBoxInBox {
    Polygon a = make_block(0.0, 0.0, 3.0, 3.0);
    Polygon b = make_block(1.0, 1.0, 2.0, 2.0);
    
    SATResult test = sat_test(a, b);
    STAssertTrue(test.penetrating, @"");
    STAssertEquals(test.penetration.x, 2.0f, @"");
    STAssertEquals(test.penetration.y, 0.0f, @"");
    
    free_polygon(a);
    free_polygon(b);
}

-(void) testBoxOnSpike {
    Polygon a = polygon_from(3, vector_from(0, -1), 
                                vector_from(1, 2), 
                                vector_from(2, -1));
    Polygon b = make_block(0, 2, 2, 4);
    
    SATResult test = sat_test(a, b);
    STAssertFalse(test.penetrating, @"");
    
    free_polygon(a);
    free_polygon(b);
}



@end
