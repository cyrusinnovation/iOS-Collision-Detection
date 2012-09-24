//
//  Wallter
//
//  Created by Najati Imam on 9/24/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//

#import <GameKit/GameKit.h>

#import "cocos2d.h"

@class Stage;

@interface RunningLayer : CCLayerColor

@property(nonatomic, retain) Stage *stage;

+ (CCScene *)scene;

@end
