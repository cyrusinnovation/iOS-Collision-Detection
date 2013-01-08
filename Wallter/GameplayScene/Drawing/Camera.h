//
// Created by najati on 9/26/12.
//

#import "cocos2d.h"
#import "Polygon.h"

#import "BoundedPolygon.h"
#import "HasFacing.h"
#import "SimulationActor.h"
#import "SimulationTicker.h"

@interface Camera : NSObject <SimulationTicker>

- (id)init:(id<BoundedPolygon,SimulationActor,HasFacing>)guy;

@property(nonatomic) float scale;
- (CGRect)currentRect;

- (void)transform:(CCSprite *)sprite to:(id <BoundedPolygon,SimulationActor,HasFacing>)location scale:(CGPoint)scale;
- (void)transform:(CGPolygon)polygon into:(CGPolygon)into __unused;
- (CGRect)transform:(CGRect)rect;

@end