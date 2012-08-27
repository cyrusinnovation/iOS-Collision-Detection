//
//  AppDelegate.h
//  SeparatingAxisTest
//
//  Created by Najati Imam on 8/25/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HelloWorldLayer.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    HelloWorldLayer     *spinners;
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
