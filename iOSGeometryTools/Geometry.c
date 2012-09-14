#include "CGPoint_ops.h"

bool doCirclesCollide(CGPoint location1, float radius1, CGPoint location2, float radius2) {
	return cgp_length_squared(cgp_subtract(location2, location1)) < ((radius1 + radius2) * (radius1 + radius2));
}
