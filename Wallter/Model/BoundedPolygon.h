//
// by najati 
// copyright Cyrus Innovation
//


@protocol BoundedPolygon <NSObject>

@property(nonatomic, readonly) CGFloat top;
@property(nonatomic, readonly) CGFloat bottom;
@property(nonatomic, readonly) CGFloat left;
@property(nonatomic, readonly) CGFloat right;
@property(nonatomic, readonly) CGPolygon polygon;

@end