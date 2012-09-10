//
//  SATResult.h
//
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#ifndef SATRESULT_H
#define SATRESULT_H

#include <stdbool.h>

#include "CGPoint_ops.h"

typedef struct {
    CGPoint penetration;
    bool penetrating;
} SATResult;

SATResult sat_result_for(CGPoint _penetration, bool separated);

#endif
