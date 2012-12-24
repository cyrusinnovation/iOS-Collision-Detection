//
// Created by najati on 12/14/12.
//

#import "BoundedPolygon.h"
#import "SimulationActor.h"

@protocol SimulationObserver
-(void)addedCharacter:(id<BoundedPolygon, SimulationActor>) character;
-(void)addedAttack:(id <BoundedPolygon, SimulationActor>) attack;
- (void)addedEnvironmentElement:(id <BoundedPolygon>)element;
@end