//
// by najati 
// copyright Cyrus Innovation
//

#import "ActorView.h"
#import "BoundedPolygon.h"

@interface ElementViewMapEntry : NSObject

@property(nonatomic, readonly, strong) ActorView *view;
@property(nonatomic, readonly, strong) id <BoundedPolygon> element;

@property(nonatomic, strong) ElementViewMapEntry *next;

- (id)init:(ActorView *)view and:(id <BoundedPolygon>)element;

+ (ElementViewMapEntry *)view:(ActorView *)view element:(id <BoundedPolygon>)element;

@end