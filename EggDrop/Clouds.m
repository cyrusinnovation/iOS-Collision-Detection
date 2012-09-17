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

-(void) resetCloud:(CCSprite*) cloud data:(void *) x{
    startingX = (int)x;
    currentCloud = cloud;
    cloud.scale = [self randomCloudScale];
    [cloud setPosition:ccp((int)startingX, [self randomStartingY])];

    CCMoveBy *move = [CCMoveBy actionWithDuration: [self timeToCrossScreen] position: ccp([self distanceToTravel], 0)];
    CCCallFuncND *resetFunc = [CCCallFuncND actionWithTarget:self selector:@selector(resetCloud:data:) data:(void *)-[self cloudWidth]];

    [cloud runAction: [CCSequence actions: move, resetFunc, nil]];
}

-(float) randomCloudScale {
    return (float)(arc4random() % 100) / 100.0 + 0.5;
}

-(int) randomStartingY {
    CGSize s = [[CCDirector sharedDirector] winSize];
    return arc4random() % (int)s.height;
}

-(float) paddedScreenWidth {
    CGSize s = [[CCDirector sharedDirector] winSize];
    return s.width + [self cloudWidth] * 1.5;
}

-(float) distanceToTravel  {
    return [self paddedScreenWidth] - startingX;
}

-(float) remainingDistancePercent {
    return [self distanceToTravel] / [self paddedScreenWidth];
}

-(float) timeToCrossScreen {
    return 50/currentCloud.scale * [self remainingDistancePercent];
}

-(int) cloudWidth {
    return [currentCloud boundingBox].size.width;
}

@end
