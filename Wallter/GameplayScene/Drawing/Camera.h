//
// Created by najati on 9/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Walter.h"

#define Y_OFFSET 80

#define X_OFFSET_WHEN_RUNNING_RIGHT 50

#define X_OFFSET_WHEN_RUNNING_LEFT 410

#define RATE_OF_RETURN 0.02

@interface Camera : NSObject
- (CGPoint)getOffset;
- (id)init:(Walter *)guy;

- (void)update;

@end