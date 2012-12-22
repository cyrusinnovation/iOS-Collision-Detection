//
// by najati 
// copyright Cyrus Innovation
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject <NSCoding>

+ (Settings *)instance;

- (void)save;

@property(assign) BOOL soundEffectsOn;
@property(assign) BOOL musicOn;
@property(retain) NSString *playerName;

@end