//
// Created by najati on 9/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CCNode.h"
#import "BadGuy.h"
#import "Camera.h"

@interface BadGuyPolygonView : CCNode
- (id)init:(BadGuy *)_badguy withOffset:(Camera *)_guy;
@end