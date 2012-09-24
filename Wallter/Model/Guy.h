//
// Created by najati on 9/24/12.
//

#import "Stage.h"
#import "ccTypes.h"
#import "WorldConstants.h"

@interface Guy : NSObject
@property(nonatomic) CGPoint location;
- (id)initIn:(Stage *)stage at:(CGPoint)at;
- (CGPolygon)polygon;
- (void)update:(ccTime)dt;

- (void)correct:(CGPoint)delta;

- (void)jump;

- (void)resetTo:(CGPoint)_location;

@end