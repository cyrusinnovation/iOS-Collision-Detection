//
//  HUD.h
//  EggDrop
//
//  Created by Jason Reid on 9/14/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "CCNode.h"
#import "Score.h"
#import "CCLabelTTF.h"
#import "CCLayer.h"

@interface HUD : CCLayer {
    CCLabelTTF* scoreLabel;
}

-(id) initWithScore:(Score*)score;

@end
