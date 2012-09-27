//
// Created by najati on 9/24/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import "Polygon.h"
#import "NewPlatformListener.h"

@class Guy;

@interface Stage : NSObject
@property(nonatomic, retain) NSMutableArray *walls;
- (void)addWall:(CGPolygon)polygon;
- (void)generateAround:(Guy *)guy listener:(NSObject<NewPlatformListener> *)listener;
@end