//
// Created by najati on 9/26/12.
//

#import "cocos2d.h"
#import "Polygon.h"

#import "BoundedPolygon.h"
#import "SimulationTicker.h"
#import "WalterSimulationActorImpl.h"

@interface Camera : NSObject <SimulationTicker>

@property(nonatomic) float scale;

// TODO not walter
- (id)init:(Walter *)guy;

- (CGPoint)getOffset;

- (void)transform:(CCSprite *)sprite to:(id <BoundedPolygon>)location scale:(CGPoint)scale;

- (void)transform:(CGPolygon)polygon into:(CGPolygon)into;

- (CGRect)currentRect;

- (CGRect)transform:(CGRect)rect;
@end