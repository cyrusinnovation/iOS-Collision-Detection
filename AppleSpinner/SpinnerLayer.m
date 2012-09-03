//
//  HelloWorldLayer.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 9/2/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//

#import "SpinnerLayer.h"

#import "CGPoint_ops.h"

@implementation SpinnerLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	SpinnerLayer *layer = [SpinnerLayer node];
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init])) {     
        [self scheduleUpdate];
        self.isTouchEnabled = YES; 
	}
	return self;
}

-(void)update:(ccTime)dt {
}


- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];    
}

- (void) draw
{
//    if (touchOne != NULL && touchTwo != NULL) {
//        glLineWidth(4);
//        glColor4ub(0, 0, 255, 0);
//        ccDrawLine(oneLocation, twoLocation);
//    }
    
    CGPoint arrowBase = CGPointMake(100, 100);
    float arrowLength = 80;
    CGPoint arrowEnd = CGPointMake(sinf(angle)*arrowLength, cosf(angle)*arrowLength);
    arrowEnd = cgp_add(arrowBase, arrowEnd);
    
    ccDrawLine(arrowBase, arrowEnd);
}

-(void) setInitialVector {
    if (touchOne == NULL || touchTwo == NULL) return;
    
    initialVector = cgp_subtract(oneLocation, twoLocation);
    initialVector = cgp_normal(initialVector);
}

-(void) handleMovingHandle {
    if (touchOne == NULL || touchTwo == NULL) return;
    
    CGPoint thisVector = cgp_subtract(oneLocation, twoLocation);
    thisVector = cgp_normal(thisVector);
    
    float dot = cgp_dot(initialVector, thisVector);
    
    angle = acosf(dot);
//    if (dot < 0) angle *= -1;

    NSLog(@"Dot: %f    Acos: %f", dot, angle);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];

    if (touchOne == NULL) {
        touchOne = touch;
        oneLocation = location;
        [self setInitialVector];
    }
    else if (touchTwo == NULL) {
        touchTwo = touch;
        twoLocation = location;
        [self setInitialVector];
    }
    
    return true;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event  
{
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];

    if (touchOne == touch) {
        oneLocation = location;        
        [self handleMovingHandle];
    }
    else if (touchTwo == touch) {
        twoLocation = location;
        [self handleMovingHandle];
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
//	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];

    if (touchOne == touch) {
        touchOne = NULL;
    }
    else if (touchTwo == touch) {
        touchTwo = NULL;
    }
}

- (void) dealloc
{
	[super dealloc];
}

@end
