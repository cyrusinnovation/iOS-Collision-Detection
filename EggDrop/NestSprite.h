//
//  NestSprite.h
//  EggDrop
//
//  Created by Najati Imam on 9/11/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "CCSprite.h"

#import "Nest.h"

@interface NestSprite : CCSprite  {
    Nest *nest;
}

-(id) init:(Nest *) nest;

@end
