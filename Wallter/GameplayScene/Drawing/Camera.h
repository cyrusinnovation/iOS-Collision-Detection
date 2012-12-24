//
// Created by najati on 9/26/12.
//


#import "cocos2d.h"
#import "Walter.h"

#define Y_OFFSET 110
#define X_OFFSET_WHEN_RUNNING_RIGHT 50
#define X_OFFSET_WHEN_RUNNING_LEFT 410
#define RATE_OF_RETURN 0.02

@interface Camera : NSObject

@property(nonatomic) float scale;

// TODO not walter
- (id)init:(Walter *)guy;
- (void)update;

- (CGPoint)getOffset;

- (void)transform:(CCSprite *)sprite to:(id <BoundedPolygon>)location;

- (void)transform:(CGPolygon)polygon into:(CGPolygon)into;
@end