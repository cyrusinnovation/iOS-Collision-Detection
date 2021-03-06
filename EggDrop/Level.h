//
// Created by najati on 9/17/12.
//


#import <Foundation/Foundation.h>


@interface Level : NSObject

@property(nonatomic) CGPoint initialEggLocation;
@property(nonatomic) CGPoint nestLocation;
@property(nonatomic, retain) NSMutableArray *starLocations;
@property(nonatomic, retain) NSMutableArray *wallLocations;


- (void)addStar:(CGPoint)location;

- (void)addWall:(CGRect)rect;
@end