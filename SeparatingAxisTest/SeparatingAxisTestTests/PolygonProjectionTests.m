//
//  PolygonProjectionTests.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/31/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "PolygonProjectionTests.h"

#include "Polygon.h"

@implementation PolygonProjectionTests

- (void)testProjectPolygonAgainstAVector {
    CGPolygon polygon = polygon_from(4, 
                                   cgp_from(0, 0),
                                   cgp_from(1, 0), 
                                   cgp_from(1, 1), 
                                   cgp_from(0, 1)
                                   );
    
    Range range = project_polygon(polygon, cgp_from(0, 1));
    
    STAssertEquals(range.min, 0.0f, @"Minimum of range was wrong");
    STAssertEquals(range.max, 1.0f, @"Maximim of range was wrong");
    
    free_polygon(polygon);
}

- (void)testRectangleOnParallelLine {
    CGPolygon polygon = make_block(0, 0, 2, 2);
    
    Range range = project_polygon(polygon, cgp_from(2, 0));
    
    STAssertEquals(range.min, 0.0f, @"Minimum of range was wrong");
    STAssertEquals(range.max, 1.0f, @"Maximim of range was wrong");
    
    free_polygon(polygon);
}

- (void)testRectangleOnLongerParallelLine {
    CGPolygon polygon = make_block(0, 0, 2, 2);
    
    Range range = project_polygon(polygon, cgp_from(4, 0));
    
    STAssertEquals(range.min, 0.0f, @"Minimum of range was wrong");
    STAssertEquals(range.max, 0.5f, @"Maximim of range was wrong");
    
    free_polygon(polygon);
}

- (void)testRectangleOnAngle {
    CGPolygon polygon = make_block(0, 0, 2, 2);
    
    Range range = project_polygon(polygon, cgp_from(2, 2));
    
    STAssertEquals(range.min, 0.0f, @"Minimum of range was wrong");
    STAssertEquals(range.max, 1.0f, @"Maximim of range was wrong");
    
    free_polygon(polygon);
}

- (void)testDiamondOnAngle {
    CGPolygon polygon = polygon_from(6, 
                                   cgp_from(0, 0), 
                                   cgp_from(2, 0), 
                                   cgp_from(4, 2), 
                                   cgp_from(4, 4), 
                                   cgp_from(2, 4), 
                                   cgp_from(0, 2)
                                   );
    
    Range range = project_polygon(polygon, cgp_from(0, 2));
    
    STAssertEquals(range.min, 0.0f, @"Minimum of range was wrong");
    STAssertEquals(range.max, 2.0f, @"Maximim of range was wrong");
    
    free_polygon(polygon);
}

@end
