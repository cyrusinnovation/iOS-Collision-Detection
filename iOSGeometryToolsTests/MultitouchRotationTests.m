//
//  MultitouchRotationTests.m
//  iOSGeometryTools
//
//  Created by Najati Imam on 9/2/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "MultitouchRotationTests.h"

#import "MultitouchRotation.h"

#include "CGPoint_ops.h"

@implementation MultitouchRotationTests

-(void) testSimple {
    MultitouchRotation* mr = [[MultitouchRotation alloc] initStartingAt:0 from:cgp(0, 0) to:cgp(0, 1)];
    
    [mr nowFrom:cgp(0, 0) to:cgp(1, 0)];
    STAssertEqualsWithAccuracy([mr currentAngle], (float) M_PI_2, 0.00001, @"");
    
    [mr nowFrom:cgp(0, 0) to:cgp(0, -1)];
    STAssertEqualsWithAccuracy([mr currentAngle], (float) M_PI, 0.00001, @"");
    
    [mr nowFrom:cgp(0, 0) to:cgp(-1, 0)];
    STAssertEqualsWithAccuracy([mr currentAngle], (float) - M_PI_2, 0.00001, @"");
}

@end
