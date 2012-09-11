//
//  CGPoint.h
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include <CoreGraphics/CoreGraphics.h>

#ifndef CGPOINT_OPS_H
#define CGPOINT_OPS_H

#define cgp(x, y) ((CGPoint) { x, y })

CGPoint cgp_copy(CGPoint b);
CGPoint cgp_subtract(CGPoint minuend, CGPoint subtrahend);
CGPoint cgp_add(CGPoint one, CGPoint another);
CGPoint cgp_normal(CGPoint v);

float cgp_dot(CGPoint a, CGPoint b);
float cgp_length_squared(CGPoint v);
float cgp_length(CGPoint v);

void cgp_normalize(CGPoint *v);
void cgp_scale(CGPoint *v, float scale);
CGPoint cgp_times(CGPoint v, float scale);
void cgp_flop(CGPoint *v);

float cgp_t(CGPoint start, CGPoint end, CGPoint point);
CGPoint cgp_project(CGPoint b, CGPoint this);

#endif
