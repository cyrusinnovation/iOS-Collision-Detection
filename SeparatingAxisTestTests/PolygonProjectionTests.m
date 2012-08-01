//
//  PolygonProjectionTests.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/31/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "PolygonProjectionTests.h"

#import "Polygon.h"

@implementation PolygonProjectionTests

- (void)testProjectPolygonAgainstAVector {
    Vector vectors[] = {
        vector_from(0, 0), 
        vector_from(1, 0), 
        vector_from(1, 1), 
        vector_from(0, 1)
    };
    Polygon polygon = polygon_from(4, vectors);
    
    Range range = project_polygon(polygon, vector_from(0, 1));
    
    STAssertEquals(range.min, 0.0f, @"Minimum of range was wrong");
    STAssertEquals(range.max, 1.0f, @"Maximim of range was wrong");
}

- (void)testRectangleOnParallelLine {
    Polygon polygon = make_block(0, 0, 2, 2);
    
    Range range = project_polygon(polygon, vector_from(2, 0));
    
    STAssertEquals(range.min, 0.0f, @"Minimum of range was wrong");
    STAssertEquals(range.max, 1.0f, @"Maximim of range was wrong");
}

- (void)testRectangleOnLongerParallelLine {
    Polygon polygon = make_block(0, 0, 2, 2);
    
    Range range = project_polygon(polygon, vector_from(4, 0));
    
    STAssertEquals(range.min, 0.0f, @"Minimum of range was wrong");
    STAssertEquals(range.max, 0.5f, @"Maximim of range was wrong");
}

- (void)testRectangleOnAngle {
    Polygon polygon = make_block(0, 0, 2, 2);
    
    Range range = project_polygon(polygon, vector_from(2, 2));
    
    STAssertEquals(range.min, 0.0f, @"Minimum of range was wrong");
    STAssertEquals(range.max, 1.0f, @"Maximim of range was wrong");
}

- (void)testDiamondOnAngle {
    Vector vectors[] = {
        vector_from(0, 0), 
        vector_from(2, 0), 
        vector_from(4, 2), 
        vector_from(4, 4), 
        vector_from(2, 4), 
        vector_from(0, 2)
    };
    Polygon polygon = polygon_from(4, vectors);
    
    Range range = project_polygon(polygon, vector_from(0, 2));
    
    STAssertEquals(range.min, 0.0f, @"Minimum of range was wrong");
    STAssertEquals(range.max, 2.0f, @"Maximim of range was wrong");
}

@end
