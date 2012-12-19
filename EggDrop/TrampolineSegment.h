//
// Created by najati on 9/17/12.
//


#import <Foundation/Foundation.h>

@interface TrampolineSegment : NSObject
- (id)initFrom:(CGPoint)start to:(CGPoint)finish;

- (CGPoint)center;

- (float)angle;

- (float)length;
@end