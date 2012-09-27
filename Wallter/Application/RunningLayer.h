//
//  Wallter
//
//  Created by Najati Imam on 9/24/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//

#import <GameKit/GameKit.h>

#import "cocos2d.h"
#import "Polygon.h"
#import "Stage.h"
#import "NewPlatformListener.h"

@interface
RunningLayer : CCLayerColor<NewPlatformListener>

@property(nonatomic, retain) Stage *stage;

+ (CCScene *)scene;

- (void)addedPlatform:(Platform *)platform;


@end
