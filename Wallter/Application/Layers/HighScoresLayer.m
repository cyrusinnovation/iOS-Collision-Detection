#import "HighScoresLayer.h"
#import "HighScores.h"
#import "HighScore.h"
#import "CGPoint_ops.h"
#import "RunningLayer.h"

@implementation HighScoresLayer {
}

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	HighScoresLayer *layer = [HighScoresLayer node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
	CGSize s = [[CCDirector sharedDirector] winSize];
	if (self = [super initWithColor:(ccColor4B) {100, 100, 220, 255} width:s.width height:s.height]) {
		self.isTouchEnabled = YES;

		HighScore *scr = [HighScores getHighestScore];
		NSString *score = [scr.name stringByAppendingFormat:@" : %d", (int) scr.score];
		CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:score fntFile:@"font.fnt"];
		CGSize s = [[CCDirector sharedDirector] winSize];
		[scoreLabel setPosition:cgp(s.width/2, s.height/2)];
		[self addChild:scoreLabel];
	}
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[RunningLayer scene] withColor:ccBLACK]];
}

@end