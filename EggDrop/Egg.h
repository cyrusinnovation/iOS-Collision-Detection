//
//  Egg.h
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@interface Egg : NSObject {
    CGPoint velocity;
    
    float terminalVelocity;
    float terminalVelocitySquared;
}

@property (readonly) float radius;
@property (readonly) CGPoint location;

-(id) initAt:(float) x and:(float) y withRadius:(float) radius;

-(void)update:(ccTime)dt; 

-(void) bounce:(float) rate;
-(void) move:(CGPoint) delta;

@end
