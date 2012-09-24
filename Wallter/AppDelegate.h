//
//  AppDelegate.h
//  Wallter
//
//  Created by Najati Imam on 9/24/12.
//  Copyright Cyrus Innovation 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate> {
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS *director_;              // weak ref
}

@property(nonatomic, retain) UIWindow *window;
@property(readonly) UINavigationController *navController;
@property(readonly) CCDirectorIOS *director;

@end
