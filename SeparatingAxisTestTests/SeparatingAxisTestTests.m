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

- (void)testCreateAPolygon
{
    Polygon *polygon = [[Polygon alloc] init: 
                        [Vector x:0 y:0], 
                        [Vector x:1 y:0], 
                        [Vector x:1 y:1], 
                        [Vector x:0 y:1], 
                        nil];
    
    STAssertNotNil(polygon, @"It was nil.");
}

- (void)testProjectPolygonAgainAVector {
    Polygon *polygon = [[Polygon alloc] init: 
                        [Vector x:0 y:0], 
                        [Vector x:1 y:0], 
                        [Vector x:1 y:1], 
                        [Vector x:0 y:1], 
                        nil];    

    Range *range = [polygon projectOnto: [Vector x:0 y:1]];
    
    STAssertEquals(range.min, 0.0f, @"Minimum of range was wrong");
    STAssertEquals(range.max, 1.0f, @"Maximim of range was wrong");
}

- (void) testBoxCrossBox {
    Polygon *a = [Polygon makeBlock: 0 : 0 : 3 : 3];
    Polygon *b = [Polygon makeBlock: -1 : 1 : 1 : 2];

    SATResult *test = [[[SeparatingAxisTest alloc] initWith:a and:b] result];
    STAssertTrue([test penetrating], @"Wasn't penetrating");
    STAssertEquals(1.0f, [[test penetration] x], @"X was wrong");
    STAssertEqualsWithAccuracy(0.0f, [[test penetration] y], 0.0, @"Y was wrong");
}

-(void) testBoxOnSpike {
    Polygon *a = [[Polygon alloc] init:[Vector x:0 y:-1], [Vector x:1 y:2], [Vector x:2 y:-1], nil];
    Polygon *b = [Polygon makeBlock: 0 : 2 : 2 : 4];

    SATResult *test = [[[SeparatingAxisTest alloc] initWith:a and:b] result];
    STAssertFalse([test penetrating], @"Was penetrating");
}



@end
