//
//  VectorAssert.m
//
//
//  Created by Najati Imam on 8/25/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "VectorAssert.h"

@implementation VectorAssert

// This is kinda shitty.
+(void) that: (CGPoint) p equals: (float) x and: (float) y within: (float) tolerance test:(SenTestCase*) test file:(const char *) file line:(int) line {
    NSMutableString *errar = [[NSMutableString alloc] init];
    
    if (fabs(p.x - x) > tolerance) {
        [errar appendFormat:@"x was outside tolerance: %f is not within %f of %f", p.x, x, tolerance];
    }
    
    if (fabs(p.y - y) > tolerance) {
        if (![errar isEqualToString:@""]) [errar appendString:@", "];
        
        [errar appendFormat:@"y was outside tolerance: %f is not within %f of %f", p.y, y, tolerance];
    }
    
    if ([errar isEqualToString:@""]) return;
    
    [test failWithException:[NSException 
                             failureInCondition: @"Point equality"
                             isTrue:true 
                             inFile:[NSString stringWithUTF8String:file] 
                             atLine:line 
                             withDescription:errar]];
}

@end
