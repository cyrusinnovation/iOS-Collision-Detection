#import "SettingsLayer.h"
#import "CGPoint_ops.h"
#import "HighScoresLayer.h"
#import "HighScores.h"

static NSString *namery = @"Player";

@implementation SettingsLayer {
	UITextField *textField;
	float score;
}

@synthesize score;

+ (CCScene *)scene:(float)score {
	CCScene *scene = [CCScene node];
	SettingsLayer *layer = [SettingsLayer node];
	layer.score = score;
	[scene addChild:layer];
	return scene;
}

- (id)init {
	CGSize s = [[CCDirector sharedDirector] winSize];
	if (self = [super initWithColor:(ccColor4B) {100, 100, 220, 255} width:s.width height:s.height]) {
		self.isTouchEnabled = YES;
		score = 0;
	}
	return self;
}

- (void)onEnterTransitionDidFinish {
	[super onEnterTransitionDidFinish];

	textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
	[textField setCenter:cgp(100, 100)];
//	CGAffineTransform transform = [self getTransform:cgp(10, 20)];
//	[textField setTransform:transform];
	[textField setDelegate:self];
	[textField setText:namery];
	[textField setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]];
	[textField setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0]];
	[[[CCDirector sharedDirector] view] addSubview:textField];
}

-(void)onExitTransitionDidStart {
	[textField removeFromSuperview];
}

- (CGAffineTransform)getTransform:(CGPoint)loc {
	CGSize s = [[CCDirector sharedDirector] winSize];
	CGSize textFrame = textField.frame.size;
	CGAffineTransform transform = CGAffineTransformMakeTranslation(textFrame.height / 2 + loc.y, s.width - textFrame.width / 2 - loc.x);
	transform = CGAffineTransformRotate(transform, -M_PI_2);
	return transform;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	CGSize s = [[CCDirector sharedDirector] winSize];
	if (location.x < s.width / 2) {
		[self editPlayerName];
	} else {
		[HighScores setHighestScore:textField.text score:score];
		[self transitionToHighScores];
	}
	return true;
}

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)transitionToHighScores {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HighScoresLayer scene] withColor:ccBLACK]];
}

- (void)editPlayerName {
	[textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)_textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)_textField {
	if (_textField != textField) return;

	[textField endEditing:YES];
 	namery = textField.text;
}

@end