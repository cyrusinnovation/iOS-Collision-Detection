//
// Created by najati on 9/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class Guy;
@protocol GuyControllerEndpoint;


@interface GuyController : NSObject
- (void)touchEnded:(CGPoint)point;

- (id)initFor:(NSObject <GuyControllerEndpoint> *)guy attackDelay:(float)delay;

+ (GuyController *)from:(NSObject <GuyControllerEndpoint> *)guy attackDelay:(float)delay;

- (void)update:(float)d;

- (void)touchMoved:(CGPoint)point;

- (void)touchStarted:(CGPoint)point;
@end