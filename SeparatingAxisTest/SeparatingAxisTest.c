//
//  SeparatingAxisTest.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "SeparatingAxisTest.h"

#import "Range.h"

#import <float.h>

void consider_axis(SeparatingAxisTestState* state, Vector axis) {
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
            vector_normalize(&state->penetration);
            vector_scale(&state->penetration, overlap.correction);
        }
    }
}

void compute_normals(SeparatingAxisTestState *state, Polygon polygon) {
    Vector start = polygon.points[polygon.point_count - 1];
    for (int i = 0; i < polygon.point_count; i++) {
        Vector perpendicular = vector_subtract(polygon.points[i], start);
        vector_normalize(&perpendicular);
        vector_flop(&perpendicular);
        
        consider_axis(state, perpendicular);
        
        start = polygon.points[i];
    }
}

SATResult sat_test(Polygon a, Polygon b) {
    SeparatingAxisTestState state;

    state.a = a;
    state.b = b;
        
    state.separated = false;
    
    state.minimumSeparationSquared = FLT_MAX;
    
    compute_normals(&state, a);
    compute_normals(&state, b);

    return sat_result_for(state.penetration, state.separated);
}

