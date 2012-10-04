//
// Created by najati on 10/3/12.
//

#import <Foundation/Foundation.h>

@interface HighScore : NSObject
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) float score;

+ (HighScore *)by:(NSString *)name of:(float)score;

- (id)initBy:(NSString *)name of:(float)score;
@end