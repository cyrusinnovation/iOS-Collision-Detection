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
	NSMutableArray *badguys;
}

@synthesize fireBallAnimation;
@synthesize walkingAnimation;
@synthesize runningAnimation;
@synthesize jumpUpAnimation;
@synthesize jumpDownAnimation;
@synthesize landAnimation;
@synthesize landThenRun;

- (void)initializeAnimations {
	{
		float frameDelay = 0.008f;

		CCAnimation *fireBall = [[CCAnimation alloc] init];
		for (int i = 1; i <= 38; i += 2) {
			NSString *frameName = [NSString stringWithFormat:@"explosion-%02d.png", i];
			[fireBall addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
		}
		[fireBall setDelayPerUnit:frameDelay];
		[fireBall setRestoreOriginalFrame:false];
		[fireBall setLoops:1];
		fireBallAnimation = [CCAnimate actionWithAnimation:fireBall];
	}

	{
		float frameDelay = 0.2f;

		CCAnimation *walking = [[CCAnimation alloc] init];
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

		walkingAnimation = [CCAnimate actionWithAnimation:walking];
	}

	{
		float frameDelay = 0.07f;

		CCAnimation *running = [[CCAnimation alloc] init];
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
		runningAnimation = [CCAnimate actionWithAnimation:running];

		CCAnimation *jumpUp = [[CCAnimation alloc] init];
		[jumpUp addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump0.png"]];
		[jumpUp addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump1.png"]];
		[jumpUp setDelayPerUnit:0.1f];
		[jumpUp setRestoreOriginalFrame:false];
		jumpUpAnimation = [CCAnimate actionWithAnimation:jumpUp];

		CCAnimation *jumpDown = [[CCAnimation alloc] init];
		[jumpDown addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump2.png"]];
		[jumpDown addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump3.png"]];
		[jumpDown addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump4.png"]];
		[jumpDown addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump5.png"]];
		[jumpDown setDelayPerUnit:frameDelay];
		[jumpDown setRestoreOriginalFrame:false];
		jumpDownAnimation = [CCAnimate actionWithAnimation:jumpDown];

		CCAnimation *land = [[CCAnimation alloc] init];
		[land addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump6.png"]];
		[land addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jump7.png"]];
		[land setDelayPerUnit:frameDelay / 2];
		[land setRestoreOriginalFrame:false];
		landAnimation = [CCAnimate actionWithAnimation:land];

		landThenRun = [CCSequence actionOne:landAnimation two:runningAnimation];
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
	badguys = [[NSMutableArray alloc] initWithCapacity:10];

	return self;
}

- (ActorView *)createMeleeAttackView:(MeleeAttack *)model {
	if ([attacks count] > 0) {
		ActorView *view = [attacks objectAtIndex:0];
		[attacks removeObjectAtIndex:0];

		[view setModel:model];

		[view update:0];
		[batchNode addChild:view.sprite];
		[view startAnimation:fireBallAnimation];
		return view;
	} else {
		ActorView *view = [[ActorView alloc] init:model scale:cgp(2, 0.7) initialFrame:@"explosion-00.png" camera:camera parent:batchNode pool:attacks];
		[view startAnimation:fireBallAnimation];
		return view;
	}
}

- (ActorView *)createBadGuyView:(BadGuy *)model {
	if ([badguys count] > 0) {
		ActorView *view = [badguys objectAtIndex:0];
		[badguys removeObjectAtIndex:0];

		[view setModel:model];

		[view update:0];
		[batchNode addChild:view.sprite];
		[view startAnimation:walkingAnimation];
		[view setFlipX:!model.facingRight];
		return view;
	} else {
		ActorView *view = [[ActorView alloc] init:model scale:cgp(1.25, 1.25) initialFrame:@"walk0.png" camera:camera parent:batchNode pool:nil];
		// TODO would it be possible to stop just the animation action
		[view startAnimation:walkingAnimation];
		[view setFlipX:!model.facingRight];
		return view;
	}
}

- (ActorView *)createWalterView:(Walter *)model {
	ActorView *view = [[ActorView alloc] init:model scale:cgp(1.25, 1.25) initialFrame:@"run0.png" camera:camera parent:batchNode pool:nil];
	// TODO would it be possible to stop just the animation action
	[view startAnimation:runningAnimation];
	[view setFlipX:!model.runningRight];
	return view;
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