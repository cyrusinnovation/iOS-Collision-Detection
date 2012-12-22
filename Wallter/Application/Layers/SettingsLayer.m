#import "SettingsLayer.h"
#import "CGPoint_ops.h"
#import "HighScoresLayer.h"
#import "Settings.h"
#import "SimpleButton.h"

@implementation SettingsLayer {
	UITextField *textField;
	CGPoint nameInputLocation;
	CGSize nameInputSize;
}

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	SettingsLayer *layer = [SettingsLayer node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
	CGSize s = [[CCDirector sharedDirector] winSize];
	self = [super initWithColor:(ccColor4B) {100, 100, 220, 255} width:s.width height:s.height];
	if (!self) return self;

	self.isTouchEnabled = YES;

	SimpleButton *button = [[SimpleButton alloc] init:self selector:@selector(editPlayerName) frame:@"button.blue.png" downFrame:@"button.blue.down.png"];
	[button setPosition:cgp(s.width - 80, 16)];
	[self addChild:button z:10];

	SimpleButton *attackButton = [[SimpleButton alloc] init:self selector:@selector(transitionToHighScores) frame:@"button.red.png" downFrame:@"button.red.down.png"];
	[attackButton setPosition:cgp(s.width - 80 * 2, 16)];
	[self addChild:attackButton z:10];

	nameInputLocation = cgp(120, 40);
	nameInputSize = (CGSize) {200, 20};

	textField = [SettingsLayer createTextField:[Settings instance].playerName delegate:self location:nameInputLocation size:nameInputSize];

	return self;
}

- (void)onEnterTransitionDidFinish {
	[super onEnterTransitionDidFinish];
	[[[CCDirector sharedDirector] view] addSubview:textField];
}

- (void)onExitTransitionDidStart {
	[[Settings instance] save];

	[super onEnterTransitionDidFinish];
	[textField removeFromSuperview];
}

#pragma mark Button callbacks

- (void)editPlayerName {
	[textField becomeFirstResponder];
}

- (void)transitionToHighScores {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HighScoresLayer scene] withColor:ccBLACK]];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)_textField {
	if (_textField != textField) return NO;
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)_textField {
	if (_textField != textField) return;
	[textField endEditing:YES];

	[Settings instance].playerName = textField.text;
}

#pragma mark handy stuff

+ (UITextField *)createTextField:(NSString *)playerName delegate:(SettingsLayer *)delegate location:(CGPoint)location size:(CGSize)size {
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	[textField setCenter:location];
	[textField setDelegate:delegate];
	[textField setText:playerName];
	[textField setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]];
	[textField setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0]];
	return textField;
}


@end