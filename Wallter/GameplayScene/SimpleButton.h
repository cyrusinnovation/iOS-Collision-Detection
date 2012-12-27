//
// by najati 
// copyright Cyrus Innovation
//

#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface SimpleButton : CCLayerColor
- (id)init:(NSString *)_upFrame downFrame:(NSString *)_downFrame batch:(CCSpriteBatchNode *)batch;

- (void)setDepressCallbackTarget:(id)_target selector:(SEL)_selector;
- (void)setReleaseCallbackTarget:(id)_target selector:(SEL)_selector;

@property(nonatomic) BOOL togglable;
@property(nonatomic) BOOL depressed;

@end