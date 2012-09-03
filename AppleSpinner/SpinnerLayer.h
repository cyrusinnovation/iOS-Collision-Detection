//
//  HelloWorldLayer.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 9/2/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//

#import "cocos2d.h"

@interface SpinnerLayer : CCLayer
{
    UITouch *touchOne;
    UITouch *touchTwo;
    
    CGPoint oneLocation;
    CGPoint twoLocation;
    
    CGPoint initialVector;
    
    float angle;
}

+(CCScene *) scene;

@end
