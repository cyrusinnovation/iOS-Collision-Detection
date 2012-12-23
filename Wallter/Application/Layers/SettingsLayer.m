#import "SettingsLayer.h"
#import "CGPoint_ops.h"
#import "HighScoresLayer.h"
#import "Settings.h"
#import "SimpleButton.h"

@implementation SettingsLayer {
	UITextField *textField;
	CGPoint nameInputLocation;
	CGSize nameInputSize;

	CCLabelBMFont *helloLabel;
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

	CGFloat topLabelHeight = s.height - 80;
	CGFloat labelSpacing = 90;
	int labelX = 110;

	helloLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Hello, %@", [Settings instance].playerName] fntFile:@"font.fnt"];
	helloLabel.position = cgp(labelX, topLabelHeight);
	helloLabel.anchorPoint = cgp(0, 0);
	[self addChild:helloLabel z:30];

	CCLabelBMFont *musicLabel = [CCLabelBMFont labelWithString:@"Music" fntFile:@"font.fnt"];
	musicLabel.position = cgp(labelX, topLabelHeight - labelSpacing);
	musicLabel.anchorPoint = cgp(0, 0);
	[self addChild:musicLabel z:30];

	CCLabelBMFont *soundLabel = [CCLabelBMFont labelWithString:@"Sound" fntFile:@"font.fnt"];
	soundLabel.position = cgp(labelX, topLabelHeight - labelSpacing*2);
	soundLabel.anchorPoint = cgp(0, 0);
	[self addChild:soundLabel z:30];

	CGFloat topButtonHeight = s.height - 90;
	CGFloat buttonSpacing = labelSpacing;
	int buttonX = 30;

	SimpleButton *editNameButton = [[SimpleButton alloc] init:self selector:@selector(editPlayerName) frame:@"pencil.png" downFrame:@"pencil.down.png"];
	[editNameButton setPosition:cgp(buttonX, topButtonHeight)];
	[self addChild:editNameButton z:10];

	SimpleButton *musicOnOffButton = [[SimpleButton alloc] init:self selector:@selector(changeMusicSetting) frame:@"speaker.on.png" downFrame:@"speaker.off.png"];
	[musicOnOffButton setPosition:cgp(buttonX, topButtonHeight - buttonSpacing)];
	[self addChild:musicOnOffButton z:10];

	SimpleButton *soundEffectsOnOffButton = [[SimpleButton alloc] init:self selector:@selector(changeSoundSetting) frame:@"speaker.on.png" downFrame:@"speaker.off.png"];
	[soundEffectsOnOffButton setPosition:cgp(buttonX, topButtonHeight - buttonSpacing*2)];
	[self addChild:soundEffectsOnOffButton z:10];

	SimpleButton *saveAndExitButton = [[SimpleButton alloc] init:self selector:@selector(transitionToHighScores) frame:@"check.png" downFrame:@"check.down.png"];
	[saveAndExitButton setPosition:cgp(s.width - 80 * 1, 16)];
	[self addChild:saveAndExitButton z:10];

	nameInputLocation = cgp(-10, -10);
	nameInputSize = (CGSize) {0, 0};

	textField = [SettingsLayer createTextField:[Settings instance].playerName delegate:self location:nameInputLocation size:nameInputSize];

	return self;
}

- (void) textChange {
	NSString *text = [NSString stringWithFormat:@"Hello, %@", textField.text];
	[helloLabel setString:text];
}

- (void)onEnterTransitionDidFinish {
	[super onEnterTransitionDidFinish];
	[[[CCDirector sharedDirector] view] addSubview:textField];
}

- (void)onExitTransitionDidStart {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[textField removeFromSuperview];

	[[Settings instance] save];

	[super onEnterTransitionDidFinish];
}

#pragma mark Button callbacks

- (void)editPlayerName {
	[textField becomeFirstResponder];
}

- (void)changeSoundSetting {
}

- (void)changeMusicSetting {
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

	[[NSNotificationCenter defaultCenter]
			addObserver:delegate
				 selector:@selector(textChange)
						 name:UITextFieldTextDidChangeNotification
					 object:textField];

	return textField;
}


@end