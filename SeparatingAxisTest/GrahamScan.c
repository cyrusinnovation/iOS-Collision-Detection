//
//  GrahamScan.c
//  SeparatingAxisTest
//
//  Created by Najati Imam on 8/2/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include <stdio.h>

#include "GrahamScan.h"

#include "CGPoint_ops.h"

#define CCW_EPSILON 0.00001f;

const float minimum_edge_length = 0.00001f;
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