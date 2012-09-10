//
//  Polygon.h
//
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#ifndef POLYGON_H
#define POLYGON_H

#include "CGPoint_ops.h"
#include "Range.h"

typedef struct {
    CGPoint *points;
    int count;
} CGPolygon;

CGPolygon polygon_from(int count, ...);
void free_polygon(CGPolygon p);

Range project_polygon(CGPolygon polgon, CGPoint vector);

CGPolygon make_block(float x1, float y1, float x2, float y2);

#endif