//
//  Trampoline.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Trampoline.h"

@implementation Trampoline

@synthesize left;
@synthesize right;


-(id)initFrom:(CGPoint) _left to:(CGPoint) _right {
    if (self = [super init]) {
        maxDepth = 10;
        
        self.left = _left;
        self.right = _right;
    }
    return self;
}


@end
