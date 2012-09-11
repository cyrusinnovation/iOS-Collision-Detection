//
//  VectorAssert.h
//
//
//  Created by Najati Imam on 8/25/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SenTestingKit/SenTestingKit.h>

#include "CGPoint_ops.h"

@interface VectorAssert : NSObject

+(void) that: (CGPoint) p equals: (float) x and: (float) y test:(SenTestCase*) test file:(const char *) file line:(int) line;

@end

#define VectorAssertEquals(actual, x, y) \
[VectorAssert that: actual equals: x and: y test:self file:__FILE__ line:__LINE__]
