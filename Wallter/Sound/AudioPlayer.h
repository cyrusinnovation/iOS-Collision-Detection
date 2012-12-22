//
// by najati 
// copyright Cyrus Innovation
//

@interface AudioPlayer : NSObject

@property(nonatomic, readonly) BOOL playingSoundEffects;
@property(nonatomic, readonly) BOOL playingMusic;

- (void)playEffect:(NSString *)string;
- (void)playBackgroundMusic:(NSString *)string;

- (void)stopBackgroundMusic;
@end