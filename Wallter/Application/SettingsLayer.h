#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface SettingsLayer : CCLayerColor <UITextFieldDelegate>
@property(nonatomic) float score;

+ (CCScene *)scene:(float)d;
@end
