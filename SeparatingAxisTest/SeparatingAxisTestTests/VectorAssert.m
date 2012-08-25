//
//  VectorAssert.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 8/25/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "VectorAssert.h"

@implementation VectorAssert

+(void) that: (CGPoint) p equals: (float) x and: (float) y test:(SenTestCase*) test file:(const char *) file line:(int) line {
    NSString *errar = [NSString stringWithFormat: @"Expected [%f, %f], actual [%f, %f]", x, y, p.x, p.y];
    
    if (p.x == x && p.y == y)
        return;
    else {
        // This is kinda shitty.
        [test failWithException:[NSException 
                                 failureInCondition: @"Point equality"
                                 isTrue:true 
                                 inFile:[NSString stringWithUTF8String:file] 
                                 atLine:line 
                                 withDescription:errar]];
    }
}

@end
