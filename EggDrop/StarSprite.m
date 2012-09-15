//
//  StarSprite.m
//  EggDrop
//
//  Created by Najati Imam on 9/11/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "StarSprite.h"

@implementation StarSprite

@synthesize star;

-(id) init:(Star *) _star {
    if (self = [super initWithFile:@"star.png"]) {
        star = _star;
        [self scheduleUpdate];
    }
    return self;
}

-(void) update:(ccTime) dt {
    [self setPosition:star.location];
}

@end
