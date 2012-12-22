//
// by najati 
// copyright Cyrus Innovation
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject <NSCoding>

+ (Settings *)instance;

- (void)save;

@property(assign) Boolean soundEffectsOn;
@property(assign) Boolean musicOn;
@property(assign) NSString *playerName;

@end