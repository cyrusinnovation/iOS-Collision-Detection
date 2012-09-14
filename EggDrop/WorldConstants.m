//
//  WorldConstants.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "WorldConstants.h"

@implementation WorldConstants

static CGPoint gravity;
static float spring;
static float terminalVelocity;

+(void) initialize
{
    gravity = CGPointMake(0, -800);
    spring = 4000;
    terminalVelocity = 600;
}

+(CGPoint) gravity
{
    return gravity; 
}

+(float) spring
{
    return spring; 
}

+(float) terminalVelocity
{
    return terminalVelocity; 
}

@end
