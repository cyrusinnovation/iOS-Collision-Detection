//
// Created by najati on 10/3/12.
//

#import <Foundation/Foundation.h>

@class HighScore;

@interface HighScores : NSObject
- (BOOL)isHighScore:(float)score;
+ (BOOL)isHighScore:(float)score;

- (HighScore *)highestScore;

+ (id)instance;

+ (HighScore *)getHighestScore;

+ (void)setHighestScore:(NSString *)string score:(float)score;
@end