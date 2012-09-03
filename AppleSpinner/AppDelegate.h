//
//  AppDelegate.h
//
//  Created by Najati Imam on 9/2/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
