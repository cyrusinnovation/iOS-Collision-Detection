//
//  Trampoline.m
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import "Trampoline.h"

#include "math.h"
#include "CGPoint_ops.h"

@implementation Trampoline

@synthesize left;
@synthesize right;

@synthesize bend;
@synthesize normal;

-(id)initFrom:(CGPoint) from to:(CGPoint) to {
    if (self = [super init]) {
        maxDepth = 10;
        
        [self setFrom: from to: to];
    }
    return self;
}

-(void) setFrom:(CGPoint) from to:(CGPoint) to {
    if (from.x < to.x) {
        self.left = from;
        self.right = to;
    } else {
        self.left = to;
        self.right = from;
    }
    
    self.bend = cgp_add(left, right);
    cgp_scale(&bend, 0.5f);
    
    normal = cgp_subtract(right, left);
    cgp_normalize(&normal);
    cgp_flop(&normal);
    
    stored = cgp(0,0);
}

-(CGPoint) center {
    CGPoint center = cgp_add(left, right);
    cgp_scale(&center, 0.5f);
    return center;
}

-(float) angle {
    CGPoint blart = cgp_subtract(right, left);
    cgp_normalize(&blart);
    return 180 * acosf(cgp_dot(blart, cgp(0, 1))) / M_PI;
}

-(float) width {
    return cgp_length(cgp_subtract(right, left));
}

float pointToLineDistance(CGPoint A, CGPoint B, CGPoint P)
{
    double normalLength = hypotf(B.x - A.x, B.y - A.y);
    return fabsf((P.x - A.x) * (B.y - A.y) - (P.y - A.y) * (B.x - A.x)) / normalLength;
}

// TODO I think since we're computing cgp_t below we might be able to tighten up the math in here
-(float) eggPenetration: (Egg *) egg {
    return pointToLineDistance(self.left, self.right, egg.location) - egg.radius;
}

-(void) handle:(Egg *) egg {
    float t = cgp_t(self.left, self.right, egg.location);
    if (t < 0 || t > 1) {
        // TODO dup
        self.bend = cgp_add(left, right);
        cgp_scale(&bend, 0.5f);
        return;
    }
    
    float penetrationDepth = [self eggPenetration:egg];
    if (penetrationDepth >= 0) {
        // TODO dup
        self.bend = cgp_add(left, right);
        cgp_scale(&bend, 0.5f);
        return;
    }
    
    float center_rate = -0.75;
    float edge_rate = -1;
    float range = center_rate - edge_rate;
    float t_rate = center_rate - range*fabs(t*2 - 1);
    
    bend = normal;
    cgp_scale(&bend, (egg.radius - penetrationDepth));
    bend = cgp_subtract(egg.location, bend);        
    
    CGPoint projected_velocity = cgp_project(normal, egg.velocity);
    stored = cgp_add(stored, projected_velocity);
    cgp_scale(&projected_velocity, t_rate);
    [egg boost:projected_velocity];
    
    float brake_vel_sqr = cgp_length_squared(projected_velocity);

    if (brake_vel_sqr < 0.1) {
        CGPoint correction = normal;
        cgp_scale(&correction, -1-penetrationDepth);
        [egg move: correction];

        CGPoint boost = stored;
        cgp_scale(&boost, -0.55);
        [egg boost: boost];
        stored = cgp(0, 0);
    
        // TODO dup
        self.bend = cgp_add(left, right);
        cgp_scale(&bend, 0.5f);
    }
}

-(void) reset {
    stored = cgp(0, 0);
}



-(CGPoint) left_center {
    CGPoint center = cgp_add(left, bend);
    cgp_scale(&center, 0.5f);
    return center;
}

-(float) left_angle {
    CGPoint blart = cgp_subtract(bend, left);
    cgp_normalize(&blart);
    return 180 * acosf(cgp_dot(blart, cgp(0, 1))) / M_PI;
}

-(float) left_width {
    return cgp_length(cgp_subtract(bend, left));
}



-(CGPoint) right_center {
    CGPoint center = cgp_add(bend, right);
    cgp_scale(&center, 0.5f);
    return center;
}

-(float) right_angle {
    CGPoint blart = cgp_subtract(right, bend);
    cgp_normalize(&blart);
    return 180 * acosf(cgp_dot(blart, cgp(0, 1))) / M_PI;
}

-(float) right_width {
    return cgp_length(cgp_subtract(right, bend));
}

@end
