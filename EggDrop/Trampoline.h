//
//  Trampoline.h
//  EggDrop
//
//  Created by Najati Imam on 9/10/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Egg.h"

@interface Trampoline : NSObject {
    float maxDepth;
    
    Boolean active;
    
    CGPoint stored;
}

@property CGPoint bend; // TODO should be private
@property CGPoint left;
@property CGPoint right;

- (id)initFrom:(CGPoint)from to:(CGPoint)to;

- (void)update:(ccTime)dt egg:(Egg *) egg;

- (void)updateGeometry;

-(void) reset;

-(void) setFrom:(CGPoint) from to:(CGPoint) to;

// TODO something needs to be able to take a trampoline and
// return a set of polygons for drawing instead of this mess
-(CGPoint) center;
-(float) angle;
-(float) width;

-(CGPoint) left_center;
-(float) left_angle;
-(float)left_length;

-(CGPoint) right_center;
-(float) right_angle;
-(float)right_length;

- (void)setSpringConstant:(float)i andDamping:(float)damping;
@end
