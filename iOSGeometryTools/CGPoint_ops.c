//
//  CGPoint.m
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include "CGPoint_ops.h"

#include "math.h"

//inline CGPoint cgp(float x, float y)
//{
//    CGPoint p; p.x = x; p.y = y; return p;
//}

CGPoint cgp_copy(CGPoint b) {
    return cgp(b.x, b.y);
}

CGPoint cgp_subtract(CGPoint minuend, CGPoint subtrahend) {
    CGPoint difference;
    difference.x = minuend.x - subtrahend.x;
    difference.y = minuend.y - subtrahend.y;
    return difference;
}

CGPoint cgp_add(CGPoint one, CGPoint another) {
    return CGPointMake(one.x + another.x, one.y + another.y);
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

float cgp_length(CGPoint v) {
    return sqrtf(cgp_length_squared(v));
}

CGPoint cgp_times(CGPoint v, float scale) {
    return (CGPoint) { v.x * scale, v.y * scale };
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

float cgp_t(CGPoint start, CGPoint end, CGPoint point)
{
    CGPoint vector = cgp_subtract(end, start);
    float oneOverDotVectorVector = 1/cgp_dot(vector, vector);
    return cgp_dot(cgp_subtract(point, start), vector)*oneOverDotVectorVector;
}
