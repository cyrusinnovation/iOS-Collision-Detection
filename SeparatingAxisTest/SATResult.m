//
//  SATResult.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "SATResult.h"

@implementation SATResult

double const EPSILON = 0.000001*0.000001;

@synthesize penetration;
@synthesize penetrating;

-(id) initWithPenetration:(Vector*) _penetration andSeparated:(Boolean) separated {
    if (self = [super init]) {
        penetration = _penetration;
        penetrating = !separated && [penetration lengthSquared] > EPSILON;
    }
    return self;
}


@end
