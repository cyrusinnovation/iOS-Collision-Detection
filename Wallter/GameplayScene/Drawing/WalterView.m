//
// Created by najati on 9/24/12.
//

#import "WalterView.h"
#import "CCSpriteFrameCache.h"
#import "CCSpriteBatchNode.h"
#import "CCSprite.h"

@implementation WalterView {
	Walter *walter;

	Camera *camera;
	CCSprite *walterSprite;
	CCSpriteBatchNode *batchNode;
}

- (id)init:(Walter *)_guy camera:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	self = [super init];
	if (!self) return self;

	walter = _guy;
	camera = _camera;

	walterSprite = [CCSprite spriteWithSpriteFrameName:@"walk0.png"];
	batchNode = _batchNode;
	[batchNode addChild:walterSprite];

	return self;
}

- (void)draw {
	CGPoint delta = [camera getOffset];

	CGPoint position = cgp_add(walter.location, delta);
	position.x += walter.width / 2;
	position.y += walterSprite.boundingBox.size.height / 2;
	[walterSprite setPosition:position];
	[super draw];
}

- (void)dealloc {
	[walter release];
	[batchNode removeChild:walterSprite cleanup:true];
	[super dealloc];
}

@end