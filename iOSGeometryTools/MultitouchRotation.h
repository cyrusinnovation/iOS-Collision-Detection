//
//  MultitouchRotation.h
//  iOSGeometryTools
//
//  Created by Najati Imam on 9/2/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#include <CoreGraphics/CoreGraphics.h>

@interface MultitouchRotation : NSObject {
    float initial_angle;
    CGPoint initial_vector;
    bool facing;
    
    float current_angle;
}

-(id) initStartingAt:(float) angle from:(CGPoint) from to:(CGPoint) to;

-(void) nowFrom:(CGPoint) from to:(CGPoint) to;
-(float) currentAngle;

@end
