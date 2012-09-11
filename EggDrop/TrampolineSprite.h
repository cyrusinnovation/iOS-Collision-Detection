//
//  TrampolineSprite.h
//  EggDrop
//
//  Created by Najati Imam on 9/11/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "CCSprite.h"

#import "Trampoline.h"

@interface TrampolineSprite : CCNode {
    Trampoline *trampoline;
    
    CCSprite *left;
    CCSprite *right;
    
    CGPoint correction;
}

-(id) init:(Trampoline *)t;

@end
