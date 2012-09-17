//
//  StarSprite.h
//  EggDrop
//
//  Created by Najati Imam on 9/11/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "CCSprite.h"

#import "Star.h"

@interface StarSprite : CCSprite  {
    Star *star;
}

@property (strong) Star* star;

-(id) init:(Star *) star;

@end
