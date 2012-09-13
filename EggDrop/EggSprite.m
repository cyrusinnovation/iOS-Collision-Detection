//
//  EggSprite.m
//  EggDrop
//
//  Created by Najati Imam on 9/11/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "EggSprite.h"

@implementation EggSprite

-(id) init:(Egg *) _egg {
    if (self = [super initWithFile:@"egg.png"]) {
        egg = _egg;
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) update:(ccTime) dt {
    [self setPosition:egg.location];
    [self setRotation:self.rotation + 0.2*egg.velocity.x];
}

@end
