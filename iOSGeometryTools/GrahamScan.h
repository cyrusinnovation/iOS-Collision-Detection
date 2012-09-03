//
//  GrahamScan.h
//
//  Created by Najati Imam on 8/2/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#ifndef GrahamScan_h
#define GrahamScan_h

#include "stdbool.h"

#include "CGPoint_ops.h"
#include "Polygon.h"

bool gs_straight_or_clockwise(CGPoint a, CGPoint b, CGPoint c);
bool gs_is_less_than_minimum_angle(CGPoint a, CGPoint b, CGPoint c);
bool gs_is_invalid_segment(CGPoint a, CGPoint b, CGPoint c);
bool gs_are_points_colinear(CGPoint basis, CGPoint a, CGPoint b);

bool gs_validate(CGPolygon poly);
CGPolygon gs_go(CGPolygon source);

#endif
