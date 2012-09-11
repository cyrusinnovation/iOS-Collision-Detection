//
//  HelloWorldLayer.h
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

#import "Trampoline.h"
#import "Egg.h"

#import "cocos2d.h"

@interface BouncingEggLayer : CCLayer
{
    NSMutableArray *trampolines;
    Egg *egg;
    
    CCSprite *tramp;
}

+(CCScene *) scene;

@end
