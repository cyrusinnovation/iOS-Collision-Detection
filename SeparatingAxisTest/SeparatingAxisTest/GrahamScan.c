//
//  GrahamScan.c
//  SeparatingAxisTest
//
//  Created by Najati Imam on 8/2/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//


#include "GrahamScan.h"

#include "CGPoint_ops.h"

#include "GrahamScanComparator.h"
#include "Stack.h"

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

#define CCW_EPSILON 0.00001f;

const float minimum_edge_length_squared = 0.00001f * 0.00001f;
const float room_for_error = 0.000005f; // This is enough for the unit tests to pass
const float cosine_of_half_minimum_angle = 0.965925826f - room_for_error; // cosine of 30deg = 12 sides polies

float CCW(CGPoint a, CGPoint b, CGPoint c) {
    return (b.x - a.x)*(c.y - b.y) - (b.y - a.y)*(c.x - b.x);
}

bool gs_straight_or_clockwise(CGPoint a, CGPoint b, CGPoint c) {
    return CCW(a, b, c) <= CCW_EPSILON;
}

float get_dot(CGPoint a, CGPoint b, CGPoint c) {
    CGPoint b_minus_a_normal = cgp_subtract(b, a);
    cgp_normalize(&b_minus_a_normal);
    
    CGPoint c_minus_b_normal = cgp_subtract(c, b);
    cgp_normalize(&c_minus_b_normal);
    
    return cgp_dot(b_minus_a_normal, c_minus_b_normal);
}

bool gs_is_less_than_minimum_angle(CGPoint a, CGPoint b, CGPoint c) {
    return get_dot(a, b, c) > cosine_of_half_minimum_angle;
}

bool gs_is_invalid_segment(CGPoint a, CGPoint b, CGPoint c) {
    bool straight_or_clockwise = gs_straight_or_clockwise(a, b, c);
    bool less_than_minimum_angle = gs_is_less_than_minimum_angle(a, b, c);
    return straight_or_clockwise || less_than_minimum_angle;
}

bool gs_are_points_colinear(CGPoint basis, CGPoint a, CGPoint b) {
    CGPoint minToA = cgp_subtract(a, basis);
    cgp_normalize(&minToA);
    CGPoint minToB = cgp_subtract(b, basis);
    cgp_normalize(&minToB);
    
    CGPoint unitX = cgp_from(1, 0);
    
    float dotXWithA = cgp_dot(unitX, minToA);
    float dotXWithB = cgp_dot(unitX, minToB);
    
    return fabs(dotXWithB - dotXWithA) < 0.0000001f;
}

CGPoint gs_get_min(CGPolygon poly) {
    CGPoint min = poly.points[0];
    for (int i = 0; i < poly.point_count ; i++) {
        CGPoint point = poly.points[i];
        if (point.y < min.y) {
            min = point;
        } else if (point.y == min.y && point.x < min.x) {
            min = point;
        }
    }
    return min;
}

bool gs_validate(CGPolygon poly) {
    if (poly.point_count < 3) return false; // degenerate polygon
    
    CGPoint min = gs_get_min(poly);
    
    int flag = 0;
    
    for (int i = 0; i < poly.point_count; i++) {
        CGPoint a = poly.points[i];
        CGPoint b = poly.points[(i+1)%poly.point_count];
        CGPoint c = poly.points[(i+2)%poly.point_count];
        float z = CCW(a, b, c);
        
        if (z == 0) return false; // linear point
        
        if (z < 0) flag |= 1;
        if (z > 0) flag |= 2;
        
        if (flag == 3) return false; // concave
        
        CGPoint minToA = cgp_subtract(a, min);
        cgp_normalize(&minToA);
        CGPoint minToB = cgp_subtract(b, min);
        cgp_normalize(&minToB);
        
        CGPoint unitX = cgp_from(1, 0);
        
        float dotXWithA = cgp_dot(unitX, minToA);
        float dotXWithB = cgp_dot(unitX, minToB);
        
        if (dotXWithB > dotXWithA) return false; // complex
    }
    
    return true;
}

bool get_next_point(CGPolygon* other_points, Stack* point_stack, int currentPoint, int* nextPoint)
{
    *nextPoint = currentPoint;
    while (true)
    {
        if (*nextPoint >= other_points->point_count) break;

        CGPoint a = other_points->points[*nextPoint];
        CGPoint b = point_stack->points[point_stack->count - 1];
        CGPoint s = cgp_subtract(a, b);
        float next_length = cgp_length_squared(s);
        if (next_length > minimum_edge_length_squared) break;
        
        (*nextPoint)++;
    }
    return *nextPoint < other_points->point_count;
}


CGPolygon gs_go(CGPolygon source) {
    CGPoint min = gs_get_min(source);
    
    CGPolygon sorted;
    sorted.point_count = source.point_count;
    sorted.points = malloc(source.point_count*sizeof(CGPoint));
    
    memcpy(sorted.points, source.points, source.point_count*sizeof(CGPoint)); 
    qsort_r(sorted.points, sorted.point_count, sizeof(CGPoint), &min, graham_comparator);
    graham_filter_colinears(&sorted);
    
    Stack stack = new_stack(sorted.point_count + 3);
    CGPoint lever = cgp_subtract(min, CGPointMake(1, 0));
    s_push(&stack, lever);
    s_push(&stack, min);
    
    int next_point = 0;
    while (get_next_point(&sorted, &stack, next_point, &next_point))
    {
        while (stack.count > 2 &&
               gs_is_invalid_segment(stack.points[stack.count - 2], stack.points[stack.count - 1], sorted.points[next_point]))
        {
            s_pop(&stack);
        }
        s_push(&stack, sorted.points[next_point]);
    }

    while (gs_is_invalid_segment(stack.points[stack.count - 2], stack.points[stack.count - 1], stack.points[1]))
    {
        s_pop(&stack);
    }
    
    free(sorted.points);
    sorted.point_count = stack.count - 1;
    int points_data_size = sorted.point_count * sizeof(CGPoint);
    sorted.points = malloc(points_data_size);
    memcpy(sorted.points, &(stack.points[1]), points_data_size); 
    return sorted;
}
