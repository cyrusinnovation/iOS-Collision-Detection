//
//  CGPoint.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "CGPoint_ops.h"

#include "math.h"

// TODO
CGPoint cgp_from(float x, float y) {
    return CGPointMake(x, y); 
}

CGPoint cgp_copy(CGPoint b) {
    return cgp_from(b.x, b.y);
}

CGPoint cgp_subtract(CGPoint minuend, CGPoint subtrahend) {
    CGPoint difference;
    difference.x = minuend.x - subtrahend.x;
    difference.y = minuend.y - subtrahend.y;
    return difference;
}

CGPoint cgp_normal(CGPoint v) {
    cgp_normalize(&v);
    return v;
}


float cgp_dot(CGPoint a, CGPoint b) {
    return a.x*b.x + a.y*b.y;
}

float cgp_length_squared(CGPoint v) {
    return v.x*v.x + v.y*v.y;
}


void cgp_scale(CGPoint *v, float scale) {
    (*v).x = (*v).x * scale;
    (*v).y = (*v).y * scale;
}

void cgp_normalize(CGPoint *v) {
    float length = sqrtf((*v).x*(*v).x + (*v).y*(*v).y);
    (*v).x = (*v).x/length;
    (*v).y = (*v).y/length;
}

void cgp_flop(CGPoint *v) {
    float x = (*v).x;
    (*v).x = -(*v).y;
    (*v).y = x;
}
