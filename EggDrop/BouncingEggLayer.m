//
//  HelloWorldLayer.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


// Import the interfaces
#import "BouncingEggLayer.h"

#import "CGPoint_ops.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

@implementation BouncingEggLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	BouncingEggLayer *layer = [BouncingEggLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {
        trampoline = [[Trampoline alloc] initFrom:cgp(60, 180) to:cgp(260, 180)];
        egg = [[Egg alloc] initAt:160 and:400 withRadius:10];
        
        [self scheduleUpdate];
	}
	return self;
}


-(void)update:(ccTime)dt {
    [egg update:dt];
}

void drawTrampoline(Trampoline *t) {
    glLineWidth(3);
    ccDrawColor4B(255, 0, 255, 0);
    ccDrawLine(t.left, t.right);
}

void drawEgg(Egg *e) {
    glLineWidth(3);
    ccDrawColor4B(255, 255, 255, 0);
    ccDrawCircle(e.location, e.radius, 360, 12, false);
}

- (void) draw
{
    drawTrampoline(trampoline);
    drawEgg(egg);
}

- (void) dealloc
{
	[super dealloc];
}

@end
