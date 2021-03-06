//
//  Nest.h
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "Egg.h"
#import "Geometry.h"

@interface Nest : NSObject {
    CGPoint location;
    float radius;
}

@property CGPoint location;
@property float radius;

-(id) initAt:(CGPoint) location;
- (bool)doesCollide:(Egg *)egg;

@end
