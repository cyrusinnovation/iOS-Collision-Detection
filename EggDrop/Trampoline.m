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

#import "WorldConstants.h"

@implementation Trampoline

@synthesize left;
@synthesize right;

@synthesize bend;
@synthesize normal;

-(id)initFrom:(CGPoint) from to:(CGPoint) to {
    if (self = [super init]) {
        maxDepth = 10;
        active = false;
        
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

// TODO I think since we're computing cgp_t below we might be able to tighten up the math in here
-(float) eggPenetration: (Egg *) _egg {
    CGPoint egg_bottom = cgp_add(_egg.location, cgp_times(normal, -_egg.radius));
    
    float distance = pointToLineDistance(self.left, self.right, egg_bottom);
    if (isAbove(left, right, egg_bottom)) return -distance;
    return distance;
}

-(void) resetBend {
    self.bend = cgp_add(left, right);
    cgp_scale(&bend, 0.5f);
}

-(void) setBendFor:(Egg *) _egg {
    bend = cgp_subtract(_egg.location, cgp_times(normal, _egg.radius));
}

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

-(void) handle:(Egg *) _egg over:(ccTime) dt {
    if (egg && egg != _egg) return;
    
    float t = cgp_t(self.left, self.right, _egg.location);
    if (t < 0 || t > 1) {
        [self reset];
        return;
    }
    
    float penetration_depth = [self eggPenetration:_egg];
    float dot = cgp_dot(cgp_normal(egg.velocity), normal);
    
    if (!egg) {
        if (dot >= 0) {
            return;
        }
        if (penetration_depth <= 0) {
            return;
        }
        if (penetration_depth > _egg.radius*2) {
            return;
        }
        
        egg = _egg;
    }
    
    if (dot >= 0) {
        if (penetration_depth < 0) {
            [self reset];
            return;
        }
    }
    
    float max_depth_for_t = scale(t, 30, 0);
    if (penetration_depth >= max_depth_for_t) {
        CGPoint egg_velocity = egg.velocity;
        float egg_velocity_component = cgp_dot(normal, egg_velocity);
        float gravity_component = cgp_dot(normal, [WorldConstants gravity]);
        [egg boost:cgp_times(normal, -egg_velocity_component/dt) during:dt];
        [egg boost:cgp_times(normal, -gravity_component) during:dt];
        [egg move:cgp_times(normal, penetration_depth-(egg_velocity_component/gravity_component * max_depth_for_t))];
        
        float bounce = scale(t, 0.8, 0.4);
        CGPoint boost = cgp_times(normal, -cgp_dot(normal, egg_velocity)/dt*bounce);
        if (cgp_length_squared(boost) >= 1) {
            [egg boost:boost during:dt];
        }
    }
    
    [self setBendFor:egg];
}



-(void) reset {
    stored = cgp(0, 0);
    egg = NULL;
    [self resetBend];
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
