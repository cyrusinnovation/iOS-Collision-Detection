//
//  najati
//  Copyright Cyrus Innovation 2012
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "IntroLayer.h"
#import "RunningLayer.h"
#import "SettingsLayer.h"

@implementation AppController

@synthesize window = window_, navController = navController_, director = director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
																 pixelFormat:kEAGLColorFormatRGB565
																 depthFormat:0
													preserveBackbuffer:NO sharegroup:nil multiSampling:NO numberOfSamples:0];

	[glView setMultipleTouchEnabled:YES];

	director_ = (CCDirectorIOS *) [CCDirector sharedDirector];
	director_.wantsFullScreenLayout = YES;

#ifdef RELEASE_DEBUG
	[director_ setDisplayStats:YES];
#endif

	[director_ setAnimationInterval:1.0 / 60];
	[director_ setView:glView];
	[director_ setDelegate:self];

	[director_ setProjection:kCCDirectorProjection2D];

	if (![director_ enableRetinaDisplay:YES])
	CCLOG(@"Retina Display Not supported");

	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];        // Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];    // Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];          // Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];  // Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	// TODO this doesn't go here
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"frames.plist"];

	[director_ pushScene:[IntroLayer scene]];

	// Adding the gl view to the window will call startAnimation on the director (so this goes AFTER you have a scene set on the director)
	[window_ setRootViewController:director_];

	// make main window visible
	[window_ makeKeyAndVisible];

	return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

// getting a call, pause the game
- (void)applicationWillResignActive:(UIApplication *)application {
	if ([navController_ visibleViewController] == director_)
		[director_ pause];
}

// call got rejected
- (void)applicationDidBecomeActive:(UIApplication *)application {
	if ([navController_ visibleViewController] == director_)
		[director_ resume];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	if ([navController_ visibleViewController] == director_)
		[director_ stopAnimation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	if ([navController_ visibleViewController] == director_)
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application {
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}
@end

