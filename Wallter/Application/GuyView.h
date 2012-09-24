//
// Created by najati on 9/24/12.
//

#import "CCNode.h"
#import "Guy.h"

@interface GuyView : CCNode
@property(nonatomic, retain) Guy *guy;

- (id)init:(Guy *)guy;
@end