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
#import "Clouds.h"
#import "Nest.h"

#import "cocos2d.h"

@interface BouncingEggLayer : CCLayer
{
    CGPoint newTrampolineAnchor;
    Trampoline *newTrampoline;
    TrampolineSprite *newTrampolineSprite;
    NSMutableArray *trampolines;
    Egg *egg;
    Nest *nest;

    Clouds *clouds;

    CCSprite *tramp;
}

+(CCScene *) scene;

@end
