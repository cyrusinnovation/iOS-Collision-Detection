//
//  GrahamScan.c
//  SeparatingAxisTest
//
//  Created by Najati Imam on 8/2/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include <stdio.h>

#include "GrahamScan.h"

#include "Vector.h"

#define CCW_EPSILON 0.00001f;

const float minimum_edge_length = 0.00001f;
const float room_for_error = 0.000005f; // This is enough for the unit tests to pass
const float cosine_of_half_minimum_angle = 0.965925826f - room_for_error; // cosine of 30deg = 12 sides polies

float CCW(Vector a, Vector b, Vector c) {
    return (b.x - a.x)*(c.y - b.y) - (b.y - a.y)*(c.x - b.x);
}

bool gs_straight_or_clockwise(Vector a, Vector b, Vector c) {
    return CCW(a, b, c) <= CCW_EPSILON;
}

float get_dot(Vector a, Vector b, Vector c) {
    Vector b_minus_a_normal = vector_subtract(b, a);
    vector_normalize(&b_minus_a_normal);
    
    Vector c_minus_b_normal = vector_subtract(c, b);
    vector_normalize(&c_minus_b_normal);
    
    return vector_dot(b_minus_a_normal, c_minus_b_normal);
}

bool gs_is_less_than_minimum_angle(Vector a, Vector b, Vector c) {
    return get_dot(a, b, c) > cosine_of_half_minimum_angle;
}

bool gs_is_invalid_segment(Vector a, Vector b, Vector c) {
    bool straight_or_clockwise = gs_straight_or_clockwise(a, b, c);
    bool less_than_minimum_angle = gs_is_less_than_minimum_angle(a, b, c);
    return straight_or_clockwise || less_than_minimum_angle;
}