//
//  Vector.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

typedef struct {
    float x;
    float y;
} Vector;


Vector vector_from(float x, float y);
Vector vector_copy(Vector b);
Vector vector_subtract(Vector minuend, Vector subtrahend);
Vector vector_normal(Vector v);

float vector_dot(Vector a, Vector b);
float vector_length_squared(Vector v);

void vector_normalize(Vector *v);
void vector_scale(Vector *v, float scale);
void vector_flop(Vector *v);
