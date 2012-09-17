//
// Created by najati on 9/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Level : NSObject

@property(nonatomic) CGPoint initialEggLocation;
@property(nonatomic) CGPoint nestLocation;
@property(nonatomic, retain) NSMutableArray *starLocations;

- (void)addStar:(CGPoint)location;
@end