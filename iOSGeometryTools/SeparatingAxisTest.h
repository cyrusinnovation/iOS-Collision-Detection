//
//
//
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "SATResult.h"

#include "Polygon.h"

#include <stdbool.h>

typedef struct {
    bool separated;
    CGPoint penetration;
    float minimumSeparationSquared;
    
    CGPolygon a;
    CGPolygon b;
} SeparatingAxisTestState;

SATResult sat_test(CGPolygon a, CGPolygon b);
