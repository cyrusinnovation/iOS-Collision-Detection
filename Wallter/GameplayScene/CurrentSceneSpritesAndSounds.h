//
// by najati 
// copyright Cyrus Innovation
//

#import "ElementOnScreenObserver.h"

@class RunningLayer;
@class ViewFactory;
@class AudioPlayer;

@interface CurrentSceneSpritesAndSounds : NSObject <ElementOnScreenObserver>
- (id)init:(RunningLayer *)_layer and:(ViewFactory *)_viewFactory and:(AudioPlayer *)audio;
@end