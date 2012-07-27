//
//  Polygon.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Vector.h"
#import "Range.h"

@interface Polygon : NSObject {
    NSArray *points;
}

@property (readonly) NSArray* points;

-(id) init:(Vector *) first, ... NS_REQUIRES_NIL_TERMINATION;

-(Range *) projectOnto:(Vector *)vector;

+(Polygon *) makeBlock: (float) x1 : (float) y1 : (float) x2 : (float) y2;

@end
