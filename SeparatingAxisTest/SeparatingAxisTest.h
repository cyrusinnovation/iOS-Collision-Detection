//
//  SeparatingAxisTest.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "SATResult.h"

#import "Polygon.h"

typedef struct {
    Boolean separated;
    Vector* penetration;
    float minimumSeparationSquared;
    
    Polygon *a;
    Polygon *b;
} SeparatingAxisTestState;

SATResult test(Polygon a, Polygon b);
