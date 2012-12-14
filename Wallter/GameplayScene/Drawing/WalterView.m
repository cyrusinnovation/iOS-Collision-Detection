//
// Created by najati on 9/24/12.
//

#import "WalterView.h"
#import "CCDrawingPrimitives.h"
#import "CCSpriteFrameCache.h"
#import "CCSpriteBatchNode.h"
#import "CCSprite.h"

@implementation WalterView {
	Walter *walter;
	ccColor4F color;

	CGPolygon drawPoly;
	DrawOffset *offset;
	CCSpriteBatchNode *batchNode;
	CCSprite *walterSprite;
}

@synthesize walter;

- (id)init:(Walter *)_guy following:(DrawOffset *) _offset {
	if (self = [super init]) {
		walter = _guy;
		offset = _offset;
		color = (ccColor4F) {0.2456, 0.4588, 0.1882, 1.0};

		drawPoly = polygon_from(4, cgp(0, 0), cgp(0, 0), cgp(0, 0), cgp(0, 0));

		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"frames.plist"];
		batchNode = [CCSpriteBatchNode batchNodeWithFile:@"frames.png"];
		walterSprite = [CCSprite spriteWithSpriteFrameName:@"walk0.png"];
		[batchNode addChild:walterSprite];
		[self addChild:batchNode];
		
	}
	return self;
}

- (void)draw {
	CGPoint delta = [offset getOffset];

	transform_polygon(walter.polygon, delta, drawPoly);
	ccDrawSolidPoly(drawPoly.points, drawPoly.count, color);

	CGPoint position = cgp_add(walter.location, delta);
	position.x += walter.width/2;
	position.y += walterSprite.boundingBox.size.height/2;
	[walterSprite setPosition:position];
	[super draw];
}

- (void)dealloc {
	[walter release];
	free_polygon(drawPoly);
	[super dealloc];
}

@end