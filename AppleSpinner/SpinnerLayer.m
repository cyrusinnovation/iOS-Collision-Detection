//
//  HelloWorldLayer.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 9/2/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//

#import "SpinnerLayer.h"

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
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}
@end
