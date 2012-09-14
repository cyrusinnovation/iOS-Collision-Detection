//
//  ScoreObserver.h
//  EggDrop
//
//  Created by Jason Reid on 9/14/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScoreObserver <NSObject>

-(void) scoreChanged:(NSInteger)value;

@end
