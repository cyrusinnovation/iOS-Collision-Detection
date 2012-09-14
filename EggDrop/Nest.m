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

-(id) initAt:(float) _x and:(float) _y {
    if (self = [super init]) {
        location = ccp(_x, _y);
        radius = 15;
    }
    return self;
}

-(void) handle:(Egg *)egg {
    if (doCirclesCollide(location, radius, egg.location, egg.radius))
        [[CCDirector sharedDirector] pause];
}

@end
