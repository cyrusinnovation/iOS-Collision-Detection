//
//  Range.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Overlap.h"

@interface Range : NSObject {
    float min;
    float max;
}

@property (readonly) float min;
@property (readonly) float max;

-(id) initWithMax:(float) _max andMin:(float) _min;

-(Overlap*) overlapWith:(Range *) that;

@end
