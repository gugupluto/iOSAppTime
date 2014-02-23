//
//  AppDelegate.m
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import "AppDelegate.h"
 
#import "MMPDeepSleepPreventer.h"
#import "AppTimeCounter.h"
#import "MMDrawerController.h"
#import "rightViewController.h"
#import "MMExampleRightSideDrawerViewController.h"
@implementation AppDelegate
int runCount = 0;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    statusController = [[StatusViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:statusController];
    

    
    rightViewController * rightSideDrawerViewController = [[rightViewController alloc] init];
 
    
    rightSideDrawerViewController.delegate = statusController;
    rightSideDrawerViewController.statusController = statusController;
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:nav
                                             leftDrawerViewController:nil
                                             rightDrawerViewController:rightSideDrawerViewController];
    
    
    [drawerController setMaximumRightDrawerWidth:200.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
    
    [drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
             }];
    
    // [self.navigationItem setTitle:@"日剧达人"];
    
    [drawerController
     setMaximumLeftDrawerWidth:240
     animated:YES
     completion:^(BOOL finished) {
     }];
    
    self.window.rootViewController =  drawerController;

    
    MMPDeepSleepPreventer * soundBoard =   [MMPDeepSleepPreventer new];
    [soundBoard startPreventSleep];
 
    [self registerforDeviceLockNotif];
    [AppTimeCounter sharedInstance];

 
    return YES;
}



static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    CFStringRef nameCFString = (CFStringRef)name;
    NSString *lockState = (__bridge NSString*)nameCFString;
    
    if([lockState isEqualToString:@"com.apple.springboard.lockcomplete"])
    {
        runCount ++;
     }
    else
    {
        runCount ++;
        if (runCount % 3 == 2)
        {
            [[AppTimeCounter sharedInstance]pauseTimer];
        }
        else
        {
            [[AppTimeCounter sharedInstance]resumeTimer];
        }
    }
}

-(void)registerforDeviceLockNotif
{
    //Screen lock notifications
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                    NULL, // observer
                                    displayStatusChanged, // callback
                                    CFSTR("com.apple.springboard.lockcomplete"), // event name
                                    NULL, // object
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
                                    NULL, // observer
                                    displayStatusChanged, // callback
                                    CFSTR("com.apple.springboard.lockstate"), // event name
                                    NULL, // object
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [statusController refresh];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+(AppDelegate *)defaultAppDelegate{
    
    AppDelegate *delegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate;
}

@end
