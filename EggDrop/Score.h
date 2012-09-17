//
//  State.h
//  EggDrop
//
//  Created by Jason Reid on 9/14/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject {
    NSInteger value;
}

@property(readonly) NSInteger value;

-(void) adjustBy:(NSInteger)d;

- (void)reset;
@end
