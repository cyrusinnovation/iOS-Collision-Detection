//
//  GrahamScan.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 8/2/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#ifndef SeparatingAxisTest_GrahamScan_h
#define SeparatingAxisTest_GrahamScan_h

#import "stdbool.h"

#import "Vector.h"

bool gs_straight_or_clockwise(Vector a, Vector b, Vector c);
bool gs_is_less_than_minimum_angle(Vector a, Vector b, Vector c);
bool gs_is_invalid_segment(Vector a, Vector b, Vector c);

#endif
