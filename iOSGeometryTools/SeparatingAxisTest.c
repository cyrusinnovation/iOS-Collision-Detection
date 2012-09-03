//
//
//
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "SeparatingAxisTest.h"

#include "Range.h"

#include <float.h>

void consider_axis(SeparatingAxisTestState* state, CGPoint axis) {
    Range aProjection = project_polygon(state->a, axis);
    Range bProjection = project_polygon(state->b, axis);

    Overlap overlap = create_overlap(aProjection, bProjection);
    
    if (!overlap.overlaps) {
        state->separated |= true;
    } else {
        float lengthSquaredOfOverlapAlongThisAxis = overlap.correction*overlap.correction;
        
        if(lengthSquaredOfOverlapAlongThisAxis < state->minimumSeparationSquared) {
            state->minimumSeparationSquared = lengthSquaredOfOverlapAlongThisAxis;

            state->penetration = axis;
            cgp_normalize(&state->penetration);
            cgp_scale(&state->penetration, overlap.correction);
        }
    }
}

void compute_normals(SeparatingAxisTestState *state, CGPolygon polygon) {
    CGPoint start = polygon.points[polygon.count - 1];
    for (int i = 0; i < polygon.count; i++) {
        CGPoint perpendicular = cgp_subtract(polygon.points[i], start);
        cgp_normalize(&perpendicular);
        cgp_flop(&perpendicular);
        
        consider_axis(state, perpendicular);
        
        start = polygon.points[i];
    }
}

SATResult sat_test(CGPolygon a, CGPolygon b) {
    SeparatingAxisTestState state;

    state.a = a;
    state.b = b;
        
    state.separated = false;
    
    state.minimumSeparationSquared = FLT_MAX;
    
    compute_normals(&state, a);
    compute_normals(&state, b);

    return sat_result_for(state.penetration, state.separated);
}

