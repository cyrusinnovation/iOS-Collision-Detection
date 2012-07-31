//
//  Vector.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Vector.h"

#import "math.h"

Vector vector_from(float x, float y) {
    Vector v;
    v.x = x;
    v.y = y;
    return v; 
}

Vector vector_copy(Vector b) {
    Vector v;
    v.x = b.x;
    v.y = b.y;
    return v;
}

Vector vector_subtract(Vector minuend, Vector subtrahend) {
    Vector difference;
    difference.x = minuend.x - subtrahend.x;
    difference.y = minuend.y - subtrahend.y;
    return difference;
}

Vector vector_normal(Vector v) {
    vector_normalize(&v);
    return v;
}


float vector_dot(Vector a, Vector b) {
    return a.x*b.x + a.y*b.y;
}

float vector_length_squared(Vector v) {
    return v.x*v.x + v.y*v.y;
}


void vector_scale(Vector *v, float scale) {
    (*v).x = (*v).x * scale;
    (*v).y = (*v).y * scale;
}

void vector_normalize(Vector *v) {
    float length = sqrtf((*v).x*(*v).x + (*v).y*(*v).y);
    (*v).x = (*v).x/length;
    (*v).y = (*v).y/length;
}

void vector_flop(Vector *v) {
    float x = (*v).x;
    (*v).x = -(*v).y;
    (*v).y = x;
}
