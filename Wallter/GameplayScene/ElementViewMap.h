//
// by najati 
// copyright Cyrus Innovation
//

#import "ElementViewMapEntry.h"

@interface ElementViewMap : NSObject
- (void)add:(ActorView *)view of:(id <BoundedPolygon>)element;
- (ActorView *)removeViewFor:(id <BoundedPolygon>)element;
@end