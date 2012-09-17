//
//  GameOverLayer.h
//  EggDrop
//
//  Created by CubbyCooker on 9/10/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {
    CCMenu* menu;
}

@property (strong, nonatomic) CCMenu* menu;

- (id)initWithBouncingEggLayer: (CCLayer*) bouncingEggLayer;

@end
