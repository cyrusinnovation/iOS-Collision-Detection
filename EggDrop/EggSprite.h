//
//  EggSprite.h
//  EggDrop
//
//  Created by Najati Imam on 9/11/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "CCSprite.h"

#import "Egg.h"

@interface EggSprite : CCSprite  {
    Egg *egg;
}

-(id) init:(Egg *) egg;

@end
