//
//  Range.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Range.h"

@implementation Range

@synthesize min;
@synthesize max;

-(id) initWithMax:(float) _max andMin:(float) _min {
    if (self = [super init]) {
        max = _max;
        min = _min;
    }
    return self;
}

-(Overlap *) overlapWith:(Range *) that {
    Boolean overlaps = !(([self max] < [that min]) || ([that max] < [self min]));
    
    if (!overlaps) {
        return [[Overlap alloc] initFrom:false and:0];
    }
    
    float left = -([self max] - [that min]);
    float right = [that max] - [self min];
    float correction = fabsf(left) < fabsf(right) ? left : right;
    return [[Overlap alloc] initFrom:true and:correction];
}


@end
