//
//  State.h
//  EggDrop
//
//  Created by Jason Reid on 9/14/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreObserver.h"

@interface Score : NSObject {
    NSInteger value;
    NSMutableSet* observers;
}

@property(readonly) NSInteger value;

-(void) addObserver:(id<ScoreObserver>)observer;

-(void) adjustBy:(NSInteger)d;

@end
