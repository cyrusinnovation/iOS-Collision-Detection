//
//  Polygon.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Polygon.h"

#import <float.h>
#import <stdlib.h>

Polygon polygon_from(int count, Vector* points) {
    Polygon ret;
    ret.point_count = count;
    ret.points = points;
    return ret;
}

Range project_polygon(Polygon polygon, Vector vector) {
    float max = FLT_MIN;
    float min = FLT_MAX;
    
    for (int i = 0; i < polygon.point_count; i++) {
        Vector point = polygon.points[i];
        float dot = vector_dot(vector, point);
        
        if (dot < min) {
            min = dot;
        }
        if (dot > max) {
            max = dot;
        }
    }
    
    float lengthSquaredOverOne = 1/vector_length_squared(vector);
    return range_from(min*lengthSquaredOverOne, max*lengthSquaredOverOne);
}

Polygon make_block(float x1, float y1, float x2, float y2) {
    Vector *vectors = malloc(4 * sizeof(Vector));
    vectors[0] = vector_from(x1, y1);
    vectors[1] = vector_from(x2, y1);
    vectors[2] = vector_from(x2, y2);
    vectors[3] = vector_from(x1, y2);
    return polygon_from(4, vectors);
}
