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
        int startingX = arc4random() % (int)s.width;
        [self resetCloud:cloud data:(void *)startingX];
    }    
} 

-(void) resetCloud:(CCSprite*) cloud data:(void *) startingX{
    cloud.scale = [self randomCloudScale];
    [cloud setPosition:ccp((int)startingX, [self randomStartingY])];

    float distanceToTravel = [self paddedScreenWidth:cloud] - (int)startingX;
    float percentDifference = distanceToTravel / [self paddedScreenWidth:cloud];
    float time = 40/cloud.scale * percentDifference;

    CCMoveBy *move = [CCMoveBy actionWithDuration: time position: ccp(distanceToTravel, 0)];
    CCCallFuncND *func = [CCCallFuncND actionWithTarget:self selector:@selector(resetCloud:data:) data:(void *)(int)-[cloud boundingBox].size.width];

    [cloud runAction: [CCSequence actions: move, func, nil]];
}

-(float) randomCloudScale {
    return (float)(arc4random() % 100) / 100.0 + 0.5;
}

-(int) randomStartingY {
    CGSize s = [[CCDirector sharedDirector] winSize];
    return arc4random() % (int)s.height;
}

-(float) paddedScreenWidth: (CCSprite *) cloud {
    CGSize s = [[CCDirector sharedDirector] winSize];
    return s.width + [cloud boundingBox].size.width * 1.5;
}

@end
