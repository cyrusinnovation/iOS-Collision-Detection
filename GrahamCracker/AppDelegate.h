//
//  AppDelegate.h
//
//  Created by Najati Imam on 8/25/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GrahamLayer.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    GrahamLayer     *spinners;
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
