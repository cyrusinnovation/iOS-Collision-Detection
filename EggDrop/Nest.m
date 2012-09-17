//
//  Nest.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Nest.h"

@implementation Nest

@synthesize location;
@synthesize radius;

-(id) initAt:(CGPoint) _location {
    if (self = [super init]) {
        location = _location;
        radius = 15;
    }
    return self;
}

-(bool) doesCollide:(Egg *)egg {
   return doCirclesCollide(location, radius, egg.location, egg.radius);
}

@end
