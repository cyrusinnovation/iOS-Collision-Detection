//
// by najati 
// copyright Cyrus Innovation
//

#import "ViewFactory.h"

@implementation ViewFactory {
	Camera *camera;
	CCSpriteBatchNode *batchNode;

	NSMutableArray *platforms;
	NSMutableArray *attacks;

	CCAnimate *landAnimation;
	CCAnimation *fireBall;
	CCAnimation *walking;
	CCAnimation *running;
}

@synthesize jumpUpAnimation;
@synthesize jumpDownAnimation;
@synthesize landThenRun;

- (void)initializeAnimations {
	{
		float frameDelay = 0.008f;

		fireBall = [[CCAnimation alloc] init];
		for (int i = 1; i <= 38; i += 2) {
			NSString *frameName = [NSString stringWithFormat:@"explosion-%02d.png", i];
			[fireBall addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
		}
		[fireBall setDelayPerUnit:frameDelay];
		[fireBall setRestoreOriginalFrame:false];
		[fireBall setLoops:1];
	}

	{
		float frameDelay = 0.2f;

		walking = [[CCAnimation alloc] init];
		[walking addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk1.png"]];
		[walking addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk2.png"]];
		[walking addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk3.png"]];
		[walking addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk4.png"]];
		[walking addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk5.png"]];
		[walking addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk6.png"]];
		[walking addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk7.png"]];
		[walking addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk0.png"]];
		[walking setDelayPerUnit:frameDelay];
		[walking setRestoreOriginalFrame:false];
		[walking setLoops:INFINITY];
	}

	{
		float frameDelay = 0.07f;

		running = [[CCAnimation alloc] init];
		[running addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run1.png"]];
		[running addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run2.png"]];
		[running addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run3.png"]];
		[running addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run4.png"]];
		[running addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run5.png"]];
		[running addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run6.png"]];
		[running addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run7.png"]];
		[running addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"run0.png"]];
		[running setDelayPerUnit:frameDelay];
		[running setRestoreOriginalFrame:false];
		[running setLoops:INFINITY];

		jumpUpAnimation = [[CCAnimation alloc] init];
		[jumpUpAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump0.png"]];
		[jumpUpAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump1.png"]];
		[jumpUpAnimation setDelayPerUnit:0.1f];
		[jumpUpAnimation setRestoreOriginalFrame:false];

		jumpDownAnimation = [[CCAnimation alloc] init];
		[jumpDownAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump2.png"]];
		[jumpDownAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump3.png"]];
		[jumpDownAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump4.png"]];
		[jumpDownAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump5.png"]];
		[jumpDownAnimation setDelayPerUnit:frameDelay];
		[jumpDownAnimation setRestoreOriginalFrame:false];

		CCAnimation *land = [[CCAnimation alloc] init];
		[land addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump6.png"]];
		[land addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump7.png"]];
		[land setDelayPerUnit:frameDelay / 2];
		[land setRestoreOriginalFrame:false];
		landAnimation = [CCAnimate actionWithAnimation:land];

		landThenRun = [CCSequence actionOne:landAnimation two:[CCAnimate actionWithAnimation:running]];
	}
}

- (id)init:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	self = [super init];
	if (!self) return self;

	camera = _camera;
	batchNode = _batchNode;

	[self initializeAnimations];

	platforms = [[NSMutableArray alloc] initWithCapacity:10];
	attacks = [[NSMutableArray alloc] initWithCapacity:10];

	return self;
}

- (ActorView *)getView:(id <BoundedPolygon, SimulationActor, HasFacing>)model scale:(CGPoint)scale animation:(CCAnimation *)animation {
	if ([attacks count] > 0) {
		ActorView *view = [attacks objectAtIndex:0];
		[attacks removeObjectAtIndex:0];

		[view reinit:model scale:scale];
		[view startAnimation:animation];
		[batchNode addChild:view.sprite];
		return view;
	} else {
		return [[ActorView alloc] init:model scale:scale animation:animation camera:camera parent:batchNode pool:attacks];
	}
}

- (ActorView *)createMeleeAttackView:(MeleeAttack *)model {
	return [self getView:model scale:cgp(2, 0.7) animation:fireBall];
}

- (ActorView *)createBadGuyView:(BadGuy *)model {
	return [self getView:model scale:cgp(1.25, 1.25) animation:walking];
}

- (ActorView *)createWalterView:(Walter *)model {
	return [self getView:model scale:cgp(1.25, 1.25) animation:running];
}

- (ActorView *)createPlatformView:(Platform *)model parent:(CCNode *)parent {
	if ([platforms count] > 0) {
		ActorView *view = [platforms objectAtIndex:0];
		[platforms removeObjectAtIndex:0];

		[view setModel:model];

		[view update:0];
		[parent addChild:view.sprite];
		return view;
	} else {
		CCSprite *sprite = [CCSprite spriteWithFile:@"stone.png" rect:(CGRect) {0, 0, model.width, model.height}];
		sprite.anchorPoint = ccp(0, 0);
		[sprite setContentSize:(CGSize) {model.width, model.height}];

		ccTexParams tp = {GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT};
		[sprite.texture setTexParameters:&tp];

		return [[ActorView alloc] init:model scale:cgp(1, 1) sprite:sprite camera:camera parent:parent pool:platforms];
	}
}

@end