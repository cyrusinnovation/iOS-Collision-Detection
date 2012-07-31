//
//  Polygon.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Polygon.h"

Polygon polygon_from(int count, Vector* points) {
    Polygon ret;
    ret.point_count = count;
    ret.points = points;
}

Range projectPolgon(Polygon polgon, Vector vector) {
    float max = FLT_MIN;
    float min = FLT_MAX;
    
    for (id point in points) {
        float dot = [vector dot:point];
        
        if (dot < min) {
            min = dot;
        }
        if (dot > max) {
            max = dot;
        }
    }
    
    float lengthSquaredOverOne = 1/[vector lengthSquared];
    return [[Range alloc] initWithMax:max*lengthSquaredOverOne andMin:min*lengthSquaredOverOne];
}

Polygon makeBlock(float x1, float y1, float x2, float y2) {
    return [[Polygon alloc] init:[Vector x:x1 y:y1], [Vector x:x2 y:y1], [Vector x:x2 y:y2], [Vector x:x1 y:y2], nil];
}
