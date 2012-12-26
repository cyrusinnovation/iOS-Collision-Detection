//
// by najati 
// copyright Cyrus Innovation
//

#import "BoundedPolygon.h"

@protocol ElementOnScreenObserver <NSObject>
-(void)elementEnteredView:(id <BoundedPolygon>)platform;
-(void)elementLeftView:(id <BoundedPolygon>)platform;
@end