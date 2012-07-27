//
//  SeparatingAxisTest.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SATResult.h"

#import "Polygon.h"

@interface SeparatingAxisTest : NSObject {
    Boolean separated;
    Vector* penetration;
    float minimumSeparationSquared;
    
    Polygon *a;
    Polygon *b;
}

@property (readonly) SATResult* result;

-(id) initWith:(Polygon *) _a and: (Polygon *) _b;
    
@end
