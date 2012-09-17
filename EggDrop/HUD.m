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
static NSString* kScoreValueChanged = @"score value changed";

-(id)initWithScore:(Score *)score {
    [self setVisible:YES];
    [self setScale:1.0f];

    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica" fontSize:32.0f];
    scoreLabel.color = ccc3(108, 54, 54);
    scoreLabel.position = cgp(30.0, 30.0);
    [self addChild:scoreLabel];

    [score addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
               context:&kScoreValueChanged];
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kScoreValueChanged) {
        NSNumber *value = [change valueForKey:NSKeyValueChangeNewKey];
        [scoreLabel setString:[NSString stringWithFormat:@"%d", [value integerValue]]];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [scoreLabel release];
    [super dealloc];
}
@end
