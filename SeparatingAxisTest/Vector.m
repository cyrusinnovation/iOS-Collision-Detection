//
//  Vector.m
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Vector.h"

@implementation Vector

+(Vector*) x:(float) x y:(float) y {
    return [[Vector alloc] initWithX:x andY:y]; 
}

- (id) init {
    if (self = [super init]) {
        coords = malloc(2 * sizeof(float));
        coords[0] = 0;
        coords[1] = 0;
    }
    return self;
}

- (id) initWithX: (float) x andY: (float) y {
    if (self = [super init]) {
        coords = malloc(2 * sizeof(float));
        coords[0] = x;
        coords[1] = y;
    }
    return self;
}

- (void) dealloc {
    free(coords);
}

-(float) x { return coords[0]; }
-(float) y { return coords[1]; }

-(float) dot:(Vector *)vector {
    return coords[0]*(vector->coords[0]) + coords[1]*(vector->coords[1]);
}

-(float) lengthSquared {
    return coords[0]*coords[0] + coords[1]*coords[1];
}

-(Vector*) minus:(Vector*) vector {
    return [Vector x:coords[0] - (vector->coords[0]) y: coords[1] - (vector->coords[1])];
}

-(void) normalize {
    float length = sqrtf(coords[0]*coords[0] + coords[1]*coords[1]);
    coords[0] = coords[0]/length;
    coords[1] = coords[1]/length;
}

-(void) flop {
    float x = coords[0];
    coords[0] = -coords[1];
    coords[1] = x;
}

-(void) copyFrom:(Vector*) vector {
    coords[0] = (vector->coords[0]);
    coords[1] = (vector->coords[1]);
}

-(void) scaleBy:(float) scale {
    coords[0] = coords[0] * scale;
    coords[1] = coords[1] * scale;
}

@end
