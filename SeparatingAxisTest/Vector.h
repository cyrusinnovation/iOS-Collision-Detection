//
//  Vector.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 7/26/12.
//  Copyright (c) 2012 Cyrus Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vector : NSObject {
    float* coords;
}

+(Vector*) x:(float) x y:(float) y;

-(float) dot:(Vector *) vector;
-(float) lengthSquared;

-(void) normalize;
-(void) flop;

-(Vector*) minus:(Vector*) vector;

-(void) copyFrom:(Vector*) vector;
-(void) scaleBy:(float) scale;

-(float) x;
-(float) y;

@end
