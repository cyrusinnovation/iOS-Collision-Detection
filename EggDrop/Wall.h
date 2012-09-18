//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface Wall : NSObject
@property(nonatomic) CGRect rectangle;

+ (NSMutableArray *)wallsFrom:(NSMutableArray *)array;

- (id)init:(CGRect)rect;
@end