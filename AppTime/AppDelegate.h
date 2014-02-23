//
//  AppDelegate.h
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import <UIKit/UIKit.h>
#import "StatusViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    StatusViewController  *statusController;
 
}
@property (strong, nonatomic) UIWindow *window;
+(AppDelegate *)defaultAppDelegate;
@end
