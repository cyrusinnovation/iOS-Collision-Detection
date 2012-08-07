//
//  GrahamScan.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 8/2/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#ifndef SeparatingAxisTest_GrahamScan_h
#define SeparatingAxisTest_GrahamScan_h

#include "stdbool.h"

#include "CGPoint_ops.h"
#include "Polygon.h"

bool gs_straight_or_clockwise(CGPoint a, CGPoint b, CGPoint c);
bool gs_is_less_than_minimum_angle(CGPoint a, CGPoint b, CGPoint c);
bool gs_is_invalid_segment(CGPoint a, CGPoint b, CGPoint c);

bool gs_validate(CGPolygon poly);

#endif
