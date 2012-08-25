//
//  HelloWorldLayer.h
//  Circler
//
//  Created by Najati Imam on 8/25/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#include "Stack.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    Stack stack;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
