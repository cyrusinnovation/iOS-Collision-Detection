//
// Created by najati on 9/26/12.
//


#import "cocos2d.h"
#import "Walter.h"

@interface Camera : NSObject

@property(nonatomic) float scale;

// TODO not walter
- (id)init:(Walter *)guy;
- (void)update;

- (CGPoint)getOffset;

- (void)transform:(CCSprite *)sprite to:(id <BoundedPolygon>)location;

- (void)transform:(CGPolygon)polygon into:(CGPolygon)into;
@end