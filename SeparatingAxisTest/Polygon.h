//
//  Polygon.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Vector.h"
#import "Range.h"

typedef struct {
    Vector *points;
    int point_count;
} Polygon;

Polygon polygon_from(int count, ...);
void free_polygon(Polygon p);

Range project_polygon(Polygon polgon, Vector vector);

Polygon make_block(float x1, float y1, float x2, float y2);
