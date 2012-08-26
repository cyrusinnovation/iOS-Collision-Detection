//
//  SwingArm.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 8/25/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "cocos2d.h"

@interface SwingArm : NSObject
{
    CGPoint center;
    CGPoint arm;
    float arm_length;
    
    float age;
}

-(id)initAt: (CGPoint) center withLength: (float) length;

-(void)update:(ccTime)dt;

-(CGPoint)endOfArm;

@end
