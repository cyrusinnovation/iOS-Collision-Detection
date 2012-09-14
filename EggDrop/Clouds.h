//
//  Clouds.h
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@interface Clouds : NSObject {
    NSMutableArray *cloudSprites;
}

@property (strong, atomic) NSMutableArray* cloudSprites;

@end
