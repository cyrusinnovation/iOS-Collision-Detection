//
// Created by najati on 9/28/12.
//

#import <Foundation/Foundation.h>

@class Walter;
@protocol GuyControllerEndpoint;


@interface WalterController : NSObject
- (void)touchEnded:(CGPoint)point;

- (id)initFor:(NSObject <GuyControllerEndpoint> *)guy attackDelay:(float)delay;

+ (WalterController *)from:(NSObject <GuyControllerEndpoint> *)guy attackDelay:(float)delay;

- (void)update:(float)d;

- (void)touchMoved:(CGPoint)point;

- (void)touchStarted:(CGPoint)point;
@end