//
// Created by najati on 9/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Guy.h"

@interface DrawOffset : NSObject
- (CGPoint)getOffset;
- (id)init:(Guy *)guy;

- (void)update;

@end