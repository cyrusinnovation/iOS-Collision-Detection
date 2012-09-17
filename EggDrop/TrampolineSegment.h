//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface TrampolineSegment : NSObject
- (id)initFrom:(CGPoint)start to:(CGPoint)finish;

- (CGPoint)center;

- (float)angle;

- (float)length;
@end