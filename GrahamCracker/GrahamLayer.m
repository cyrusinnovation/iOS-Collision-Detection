//
//  HelloWorldLayer.m
//  Circler
//
//  Created by Najati Imam on 8/25/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//


// Import the interfaces
#import "GrahamLayer.h"

#include "Polygon.h"
#include "GrahamScan.h"

#import "SwingArm.h"

// HelloWorldLayer implementation
@implementation GrahamLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GrahamLayer *layer = [GrahamLayer node];
	[scene addChild:layer z:0 tag:1];
	return scene;
}

-(id) init
{
	if( (self=[super init])) {     
        [self scheduleUpdate];
        self.isTouchEnabled = YES; 
        
        stack = new_stack(300);
        arms = [[NSMutableArray alloc] init];
        
        dragging = false;
    }
	return self;
}

-(void)update:(ccTime)dt {
    for (SwingArm *arm in arms) {
        [arm update:dt];
    }
}

-(void) drawSwingArmFrom: (CGPoint) from to: (CGPoint) to
{    
    glLineWidth(3);
    glColor4ub(60, 60, 60, 0);
    ccDrawLine(from, to);
    
    glPointSize(6);
    glColor4ub(100, 100, 100, 0);
    ccDrawPoint(from);

    glPointSize(4);
    glColor4ub(255, 0, 255, 0);
    ccDrawPoint(to);
}

-(void) drawSwingArm: (SwingArm *) arm
{
    [self drawSwingArmFrom: [arm center] to: [arm endOfArm]];
}

void drawShape(CGPoint *points, int count)
{
    int i = 0;
    for (; i < count-1; i++) {
        ccDrawLine(points[i], points[i+1]);
    }
    ccDrawLine(points[i], points[0]);
}

- (void) draw
{
    for (int i = 0; i < [arms count]; i++) {
        SwingArm *arm = [arms objectAtIndex:i];
        [self drawSwingArm:arm];
        stack.points[i] = [arm endOfArm];
    }
    
    if (stack.count >= 3) {    
        CGPolygon shape;
        shape.points = stack.points;
        shape.count = stack.count;
        
        CGPolygon better_shape = gs_go(shape);
        
        glLineWidth(4);
        glColor4ub(0, 0, 255, 0);
        drawShape(better_shape.points, better_shape.count);
        
        free_polygon(better_shape);
    }
        
    if (dragging) {
        [self drawSwingArmFrom:dragStart to:dragEnd];
    }
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    dragStart = location;
    dragEnd = location;
    
    dragging = true;
    
    return true;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event  
{
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    dragEnd = location;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    s_push(&stack, CGPointMake(0, 0));    
    [arms addObject:[[SwingArm alloc] initFrom:dragStart to:location]];
    
    dragging = false;
}

@end
