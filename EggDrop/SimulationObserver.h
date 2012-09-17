//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


@class Star;

@protocol SimulationObserver <NSObject>

-(void) newStar:(Star *) star;
-(void) starCaught:(Star *) star;

@end