#import <CoreGraphics/CoreGraphics.h>
#import "SettingsLayer.h"
#import "CGPoint_ops.h"

@implementation SettingsLayer {
	UITextField *textField;
}

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	SettingsLayer *layer = [SettingsLayer node];
	[scene addChild:layer];
	return scene;
}

- (id)init {
	CGSize s = [[CCDirector sharedDirector] winSize];
	if (self = [super initWithColor: (ccColor4B) {100,100,220,255} width:s.width height:s.height]) {
		self.isTouchEnabled = YES;
	}
	return self;
}

- (void)onEnter {

	NSLog(@"landscape %d", UIDeviceOrientationIsLandscape([[CCDirector sharedDirector] interfaceOrientation]));

	textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
	[textField setCenter:cgp(0, 0)];
	CGAffineTransform transform = [self getTransform:cgp(10, 20)];
	[textField setTransform:transform];
	[textField setDelegate:self];
	[textField setText:@"Player"];
	[textField setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]];
	[textField setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0]];
	[[[[CCDirector sharedDirector] view] window] addSubview:textField];
}

- (CGAffineTransform)getTransform:(CGPoint)loc {
	CGSize s = [[CCDirector sharedDirector] winSize];
	CGSize textFrame = textField.frame.size;
	CGAffineTransform transform = CGAffineTransformMakeTranslation(textFrame.height/2 + loc.y, s.width - textFrame.width/2 - loc.x);
	transform = CGAffineTransformRotate(transform, -M_PI_2);
	return transform;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self specifyStartLevel];
}

- (void)specifyStartLevel {
	[textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)_textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)_textField {
	if (_textField != textField) return;

	[textField endEditing:YES];
	NSString *result = textField.text;
	NSLog([NSString stringWithFormat:@"entered: %@", result]);
}

@end