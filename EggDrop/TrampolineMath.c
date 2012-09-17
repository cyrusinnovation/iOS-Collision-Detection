
#include "TrampolineMath.h"

#include <math.h>

float scale(float value, float center_rate, float edge_rate) {
    float range = center_rate - edge_rate;
    return center_rate - range*fabs(value*2 - 1);
}

float interpolate(float value, float zero, float one) {
    return zero + (one-zero)*value;
}

float clamped_range(float x, float min, float max) {
    if (x < min) {
        return 0;
    }
    if (x > max) {
        return 1;
    }
    if (min == max) {
        return 1;
    }
    return (x - min)/(max - min);
}

float pointToLineDistance(CGPoint a, CGPoint b, CGPoint c)
{
    double normalLength = hypotf(b.x - a.x, b.y - a.y);
    // TODO OPT this looks like the cross product from below,
    // it looks like the negative and it's being abs'ed - so maybe ...
    return fabsf((b.y - a.y)*(c.x - a.x) - (b.x - a.x)*(c.y - a.y)) / normalLength;
}

bool isAbove(CGPoint a,CGPoint b, CGPoint c){
    return ((b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x)) > 0;
}