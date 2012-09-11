//
//  Trampoline.h
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Egg.h"

@interface Trampoline : NSObject {
    float maxDepth;
    
    CGPoint normal;
    
    CGPoint stored;
}

@property CGPoint left;
@property CGPoint right;

-(id)initFrom:(CGPoint) left to:(CGPoint) right;

-(void) handle:(Egg *) egg;

-(void) reset;

@end
