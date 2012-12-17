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
#import "PlatformAddedObserver.h"
#import "GuyControllerEndpoint.h"
#import "CharacterAddedObserver.h"

#define INTERFACE_LAYER 100

@interface RunningLayer : CCLayerColor<CharacterAddedObserver, GuyControllerEndpoint>
+ (CCScene *)scene;
@end
