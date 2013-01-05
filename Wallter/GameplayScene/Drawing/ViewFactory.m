//
// by najati 
// copyright Cyrus Innovation
//

#import "ViewFactory.h"
#import "FileAccess.h"

@implementation ViewFactory {
	Camera *camera;
	CCSpriteBatchNode *batchNode;

	NSMutableArray *platforms;
	NSMutableArray *attacks;

	CCAnimation *fireBall;
	CCAnimation *walk;
	CCAnimation *run;
}

@synthesize jumpUp;
@synthesize jumpDown;
@synthesize landThenRun;

- (void)initializeAnimations {
	NSDictionary *dictionary = readPList(@"animations");

	fireBall = [self makeAnimationFromDictionary:dictionary[@"fireball"]];
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

- (ActorView *)getView:(id <BoundedPolygon, SimulationActor, HasFacing>)model scale:(CGPoint)scale animation:(CCAnimation *)animation parent:(CCSpriteBatchNode *)parent {
	if ([attacks count] > 0) {
		ActorView *view = [attacks objectAtIndex:0];
		[attacks removeObjectAtIndex:0];

		[view setModel:model];
		[view setSpriteScale:scale];
		[view startAnimation:animation];
		[parent addChild:view.sprite];
		return view;
	} else {
		return [[ActorView alloc] init:model scale:scale animation:animation camera:camera parent:parent pool:attacks];
	}
}

- (ActorView *)createMeleeAttackView:(MeleeAttack *)model {
	return [self getView:model scale:cgp(2, 0.7) animation:fireBall parent:batchNode];
}

- (ActorView *)createBadGuyView:(BadGuy *)model {
	return [self getView:model scale:cgp(1.25, 1.25) animation:walk parent:batchNode];
}

- (ActorView *)createWalterView:(Walter *)model {
	return [self getView:model scale:cgp(1.25, 1.25) animation:run parent:batchNode];
}

- (ActorView *)createPlatformView:(Platform *)model parent:(CCNode *)parent {
	CGPoint scale = cgp(1, 1);

	if ([platforms count] > 0) {
		ActorView *view = [platforms objectAtIndex:0];
		[platforms removeObjectAtIndex:0];

		[view setModel:model];
		[view setSpriteScale:scale];
		[parent addChild:view.sprite];
		return view;
	} else {
		return [[ActorView alloc] init:model scale:scale spriteFileName:@"stone.png" camera:camera parent:parent pool:platforms];
	}
}

@end