//
//  Polygon.m
//
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "Polygon.h"

#include <float.h>
#include <stdlib.h>
#include <stdarg.h>
#include <assert.h>

CGPolygon polygon_from(int count, ...) {
    va_list args;
    va_start(args, count);
    
    CGPolygon ret;
    ret.count = count;
    ret.points = malloc(count * sizeof(CGPoint));
    
    for (int i = 0; i < count; i++) {
        ret.points[i] = va_arg(args, CGPoint);
    }
    va_end(args);
    
    return ret;
}

void free_polygon(CGPolygon p) {
    free(p.points);
}

Range project_polygon(CGPolygon polygon, CGPoint vector) {
    float max = -FLT_MAX;
    float min = FLT_MAX;
    
    for (int i = 0; i < polygon.count; i++) {
        CGPoint point = polygon.points[i];
        float dot = cgp_dot(vector, point);
        
        if (dot < min) {
            min = dot;
        }
        if (dot > max) {
            max = dot;
        }
    }
    
    float lengthSquaredOverOne = 1/cgp_length_squared(vector);
    return range_from(min*lengthSquaredOverOne, max*lengthSquaredOverOne);
}

void transform_polygon(CGPolygon initial, CGPoint delta, CGPolygon final) {
	assert(final.count >= initial.count);

	for (int i = 0; i < initial.count; i++) {
		final.points[i] = cgp_add(initial.points[i], delta);
	}
}

CGPolygon make_block(float x1, float y1, float x2, float y2) {
    return polygon_from(4, cgp(x1, y1),
                        cgp(x2, y1),
                        cgp(x2, y2),
                        cgp(x1, y2));
}
