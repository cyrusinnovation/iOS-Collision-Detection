//
//  NestSprite.m
//  EggDrop
//
//  Created by Najati Imam on 9/11/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "NestSprite.h"

@implementation NestSprite

-(id) init:(Nest *) _nest {
    if (self = [super initWithFile:@"nest.png"]) {
        nest = _nest;
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) update:(ccTime) dt {
    [self setPosition:nest.location];
}

@end
