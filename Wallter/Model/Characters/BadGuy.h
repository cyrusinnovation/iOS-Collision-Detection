//
// Created by najati on 9/25/12.
//

#import "ProxyCollection.h"
#import <Foundation/Foundation.h>
#import "Polygon.h"
#import "BoundedPolygon.h"
#import "SimulationActor.h"
#import "BadGuyObserver.h"
#import "HasFacing.h"

@interface BadGuy : NSObject<BoundedPolygon, SimulationActor, HasFacing>

@property(nonatomic, readonly) CGPolygon polygon;
@property(nonatomic, readonly) BOOL facingRight;

@property(nonatomic, readonly, strong) ProxyCollection<BadGuyObserver> *observer;

- (id)init:(CGPoint)point facingRight:(BOOL)_facingRight;

@end