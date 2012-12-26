//
// Created by najati on 9/25/12.
//

#import "ProxyCollection.h"
#import <Foundation/Foundation.h>
#import "Polygon.h"
#import "BoundedPolygon.h"
#import "SimulationActor.h"
#import "BadGuyObserver.h"

@interface BadGuy : NSObject<BoundedPolygon, SimulationActor>

@property(nonatomic, readonly) CGPolygon polygon;
@property(nonatomic, readonly) bool dead;
@property(nonatomic, readonly) bool facingRight;

@property(nonatomic, readonly, strong) ProxyCollection<BadGuyObserver> *observer;

- (id)init:(CGPoint)point facingRight:(BOOL)_facingRight;

@end