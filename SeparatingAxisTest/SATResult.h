//
//  SATResult.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include <stdbool.h>

#import "Vector.h"

typedef struct {
    Vector penetration;
    bool penetrating;
} SATResult;

SATResult sat_result_for(Vector _penetration, bool separated);