//
// by najati 
// copyright Cyrus Innovation
//

#import "cocos2d.h"

@interface BlockOverTimeAction : CCActionInterval
-(id)init:(void (^) (ccTime))block duration:(float) duration;
@end