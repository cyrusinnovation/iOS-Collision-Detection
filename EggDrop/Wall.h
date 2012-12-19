//
// Created by najati on 9/17/12.
//


#import <Foundation/Foundation.h>

#import "Egg.h"

@interface Wall : NSObject
@property(nonatomic) CGRect rectangle;

+ (NSMutableArray *)wallsFrom:(NSMutableArray *)array;

- (id)init:(CGRect)rect;

- (void)update:(ccTime)dt egg:(Egg *)egg;

@end