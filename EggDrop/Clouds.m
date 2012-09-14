//
//  Clouds.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Clouds.h"

@implementation Clouds

@synthesize cloudSprites;

-(id) init
{
    if (self=[super init]){
        cloudSprites = [[NSMutableArray alloc] init];
        [self createCloudPool];
        [self addClouds];
    }
    return self;
}

-(void) createCloudPool {
    [cloudSprites addObject: [CCSprite spriteWithFile:@"cloud1.png"]];
    [cloudSprites addObject: [CCSprite spriteWithFile:@"cloud2.png"]];
    [cloudSprites addObject: [CCSprite spriteWithFile:@"cloud3.png"]];
    [cloudSprites addObject: [CCSprite spriteWithFile:@"cloud4.png"]];
}

-(void) addClouds {
    CGSize s = [[CCDirector sharedDirector] winSize];
    for (CCSprite *cloud in cloudSprites) {
        int x = arc4random() % (int)s.width;
        [self resetCloud:cloud data:(void *)x];
    }    
} 

-(void) resetCloud:(CCSprite*) cloud data:(void *) startingX{
    CGSize s = [[CCDirector sharedDirector] winSize];
    int y = arc4random() % (int)s.height;
    float scale = (float)(arc4random() % 100) / 100.0 + 0.5;
    cloud.scale = scale;

    [cloud setPosition:ccp((int)startingX, y)];

    float distanceOfScreen = s.width + [cloud boundingBox].size.width * 1.5;
    float distanceToTravel = distanceOfScreen - (int)startingX;
    float percentDifference = distanceToTravel / distanceOfScreen;
    float time = 40/scale * percentDifference;

    CCMoveBy *move = [CCMoveBy actionWithDuration: time position: ccp(distanceToTravel, 0)];
    CCCallFuncND *func = [CCCallFuncND actionWithTarget:self selector:@selector(resetCloud:data:) data:(void *)(int)-[cloud boundingBox].size.width];

    [cloud runAction: [CCSequence actions: move, func, nil]];
}

@end
