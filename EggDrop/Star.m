//
//  Star.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Star.h"

@implementation Star

@synthesize location;
@synthesize radius;

-(id) initAt:(float) _x and:(float) _y {
    if (self = [super init]) {
        location = ccp(_x, _y);
        radius = 8;
    }
    return self;
}

-(bool) doesCollide:(Egg *)egg {
    return doCirclesCollide(location, radius, egg.location, egg.radius);
}

@end
