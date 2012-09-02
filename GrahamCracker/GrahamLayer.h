//
//  HelloWorldLayer.h
//  Circler
//
//  Created by Najati Imam on 8/25/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//

#import "cocos2d.h"

#include "Stack.h"

@interface GrahamLayer : CCLayer
{
    Stack stack;
    
    NSMutableArray *arms;
    
    Boolean dragging;
    CGPoint dragStart;
    CGPoint dragEnd;
}

+(CCScene *) scene;

@end
