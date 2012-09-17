

// TODO this stuff should probably all be in various other places, I just wanted to get it out of Trampoline

#ifndef __TRAMPOLINE_MATH_H__
#define __TRAMPOLINE_MATH_H__

#include <CoreGraphics/CoreGraphics.h>

float scale(float value, float center_rate, float edge_rate);
float interpolate(float value, float zero, float one);
float clamped_range(float x, float min, float max);
float pointToLineDistance(CGPoint a, CGPoint b, CGPoint c);
bool isAbove(CGPoint a,CGPoint b, CGPoint c);

#endif