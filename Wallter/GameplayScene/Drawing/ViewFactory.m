//
// by najati 
// copyright Cyrus Innovation
//

#import "ViewFactory.h"
#import "FileAccess.h"

@implementation ViewFactory {
	Camera *camera;
	CCSpriteBatchNode *batchNode;

	NSMutableArray *platformViews;
	NSMutableArray *spriteSheetViews;

	CCAnimation *fireBall;
	CCAnimation *walk;
	CCAnimation *run;
	CCAnimation *sword;
}

@synthesize jumpUp;
@synthesize jumpDown;
@synthesize landThenRun;

- (id)init:(Camera *)_camera batchNode:(CCSpriteBatchNode *)_batchNode {
	self = [super init];
	if (!self) return self;

	camera = _camera;
	batchNode = _batchNode;

	[self initializeAnimations];

	platformViews = [[NSMutableArray alloc] initWithCapacity:10];
	spriteSheetViews = [[NSMutableArray alloc] initWithCapacity:10];

	return self;
}

- (void)initializeAnimations {
	NSDictionary *dictionary = readPList(@"animations");

	fireBall = [self makeAnimationFromDictionary:dictionary[@"fireball"]];
	sword = [self makeAnimationFromDictionary:dictionary[@"sword"]];
	walk = [self makeAnimationFromDictionary:dictionary[@"walk"]];
	run = [self makeAnimationFromDictionary:dictionary[@"run"]];
	jumpUp = [self makeAnimationFromDictionary:dictionary[@"jumpUp"]];
	jumpDown = [self makeAnimationFromDictionary:dictionary[@"jumpDown"]];

	CCAnimation *land = [self makeAnimationFromDictionary:dictionary[@"land"]];
	landThenRun = [CCSequence actionOne:[CCAnimate actionWithAnimation:land] two:[CCAnimate actionWithAnimation:run]];
}

- (CCAnimation *)makeAnimationFromDictionary:(NSDictionary *)params {
	CCAnimation *animation = [[CCAnimation alloc] init];

	NSArray *frames = [params objectForKey:@"frames"];

	for (NSString *frame in frames) {
		[animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frame]];
	}

	float frameDelay = [[params objectForKey:@"delay"] floatValue];
	[animation setDelayPerUnit:frameDelay];

	[animation setRestoreOriginalFrame:false];

	if ([[params objectForKey:@"looping"] boolValue]) {
		[animation setLoops:INFINITY];
	} else {
		[animation setLoops:1];
	}

	return animation;
}

- (ActorView *)getView:(id <BoundedPolygon, SimulationActor, HasFacing>)model scale:(CGPoint)scale animation:(CCAnimation *)animation parent:(CCSpriteBatchNode *)parent {
	if ([spriteSheetViews count] > 0) {
		ActorView *view = [spriteSheetViews objectAtIndex:0];
		[spriteSheetViews removeObjectAtIndex:0];

		[view setModel:model];
		[view setSpriteScale:scale];
		[view startAnimation:animation];
		[parent addChild:view.sprite];
		return view;
	} else {
		return [[ActorView alloc] init:model scale:scale animation:animation camera:camera parent:parent pool:spriteSheetViews];
	}
}

- (ActorView *)createMeleeAttackView:(MeleeAttack *)model {
	return [self getView:model scale:cgp(2, 2) animation:sword parent:batchNode];
}

- (ActorView *)createBadGuyView:(BadGuy *)model {
	return [self getView:model scale:cgp(1.25, 1.25) animation:walk parent:batchNode];
}

- (ActorView *)createWalterView:(Walter *)model {
	return [self getView:model scale:cgp(1.25, 1.25) animation:run parent:batchNode];
}

- (ActorView *)createPlatformView:(Platform *)model parent:(CCNode *)parent {
	CGPoint scale = cgp(1, 1);

	if ([platformViews count] > 0) {
		ActorView *view = [platformViews objectAtIndex:0];
		[platformViews removeObjectAtIndex:0];

		[view setModel:model];
		[view setSpriteScale:scale];
		[parent addChild:view.sprite];
		return view;
	} else {
		return [[ActorView alloc] init:model scale:scale spriteFileName:@"stone.png" camera:camera parent:parent pool:platformViews];
	}
}

@end