//
//  HUD.m
//  EggDrop
//
//  Created by Jason Reid on 9/14/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "HUD.h"
#import "CGPoint_ops.h"

@implementation HUD 

-(id)initWithScore:(Score *)score {
    [score addObserver:self];
    [self setVisible:YES];
    [self setScale:1.0f];
    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica" fontSize:32.0f];
    scoreLabel.color = ccc3(108, 54, 54);
    scoreLabel.position = cgp(30.0, 30.0);
    [self addChild:scoreLabel];
    return self;
}

-(void) scoreChanged:(NSInteger)value {
    [scoreLabel setString:[NSString stringWithFormat:@"%d", value]];
}

- (void)dealloc {
    [scoreLabel release];
    [super dealloc];
}
@end
