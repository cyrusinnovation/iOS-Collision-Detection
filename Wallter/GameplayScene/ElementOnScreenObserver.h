//
// by najati 
// copyright Cyrus Innovation
//

#import "BoundedPolygon.h"

@protocol ElementOnScreenObserver <NSObject>
-(void) platformEnteredView:(id <BoundedPolygon>)platform;
-(void) platformLeftView:(id <BoundedPolygon>)platform;
@end