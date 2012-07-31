//
//  Overlap.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Overlap.h"

@implementation Overlap

@synthesize overlaps;
@synthesize correction;

-(id) initFrom:(Boolean) _overlaps and: (float) _correction {
    if (self = [super init]) {
        correction = _correction;
        overlaps = _overlaps;
    }
    return self;
}

@end
