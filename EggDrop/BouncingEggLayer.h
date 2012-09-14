//
//  HelloWorldLayer.h
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

#import "Trampoline.h"
#import "TrampolineSprite.h"
#import "Egg.h"

#import "cocos2d.h"

@interface BouncingEggLayer : CCLayer
{
    CGPoint newTrampolineAnchor;
    Trampoline *newTrampoline;
    TrampolineSprite *newTrampolineSprite;
    NSMutableArray *trampolines;
    NSMutableArray *clouds;
    Egg *egg;
    
    CCSprite *tramp;
}

+(CCScene *) scene;

@end
