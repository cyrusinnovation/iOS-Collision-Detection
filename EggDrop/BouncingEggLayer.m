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
        trampolines = [[NSMutableArray alloc] init];
        [trampolines addObject: [[Trampoline alloc] initFrom:cgp(200, 300) to:cgp(280, 340)] ];
        [trampolines addObject: [[Trampoline alloc] initFrom:cgp(40, 220) to:cgp(120, 200)] ];
        egg = [[Egg alloc] initAt:160 and:400 withRadius:10];
        [egg boost:cgp(2, 0)];
        
        [self scheduleUpdate];
        
        self.isTouchEnabled = YES; 
	}
	return self;
}


-(void)update:(ccTime)dt {
    [egg update:dt];
    for (Trampoline *trampoline in trampolines) {
        [trampoline handle: egg];
    }
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
    for (Trampoline *trampoline in trampolines) {
        drawTrampoline(trampoline);
    }
    drawEgg(egg);
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];

    [egg resetTo:location];
    [egg boost:cgp(2, 0)];

    for (Trampoline *trampoline in trampolines) {
        [trampoline reset];
    }
    
    return true;
}

- (void) dealloc
{
	[super dealloc];
}

- (void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];    
}


@end
