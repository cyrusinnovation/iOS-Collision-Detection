//
// Created by najati on 9/24/12.
//

#import "CCNode.h"
#import "Walter.h"
#import "DrawOffset.h"

@interface WalterView : CCNode
@property(nonatomic, retain) Walter *walter;
- (id)init:(Walter *)_guy following:(DrawOffset *)_offset;
@end