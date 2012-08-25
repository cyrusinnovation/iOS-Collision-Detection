//
//  SATResult.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "SATResult.h"

double const EPSILON = 0.000001*0.000001;

SATResult sat_result_for(CGPoint _penetration, bool separated) {
    SATResult ret;
    ret.penetration = _penetration;
    ret.penetrating = !separated && cgp_length_squared(_penetration) > EPSILON;
    return ret;
}
