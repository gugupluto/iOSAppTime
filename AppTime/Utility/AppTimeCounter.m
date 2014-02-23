//
//  AppTimeCounter.m
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import "AppTimeCounter.h"
#import  <objc/runtime.h>
#import <sys/sysctl.h>
#import <dlfcn.h>
#import "AppTimeAccess.h"
#import "NSDate+Helper.h"

@implementation AppTimeCounter
static AppTimeCounter *instance = nil;

#define SBSERVPATH "/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices"
#define UIKITPATH "/System/Library/Framework/UIKit.framework/UIKit"
#define PREPATH  "/System/Library/PrivateFrameworks/Preferences.framework/Preferences"


+(AppTimeCounter*)sharedInstance
{
    @synchronized(self)
    {
        if (nil == instance)
        {
            instance = [[super allocWithZone:NULL] init];
 
        }
    }
    return instance;
}

-(id)init
{
    if (self = [super init])
    {
        [self initPrivateAPI];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        currentTopAppId = [self getTopMostAppBundleId];
        if (currentTopAppId != nil && ![currentTopAppId isEqualToString:@""])
        {
            dateForTopmostApp = [NSDate date];
            runTime = 0;
        }
    }
    return  self;
}

-(void)initPrivateAPI
{
    uikit = dlopen(UIKITPATH, RTLD_LAZY);
    SBSSpringBoardServerPort =
    dlsym(uikit, "SBSSpringBoardServerPort");
    p = (mach_port_t *)SBSSpringBoardServerPort();
    dlclose(uikit);
    sbserv = dlopen(SBSERVPATH, RTLD_LAZY);
    
    SBSCopyApplicationDisplayIdentifiers =dlsym(sbserv, "SBSCopyApplicationDisplayIdentifiers");
    
    SBDisplayIdentifierForPID =
    dlsym(sbserv, "SBDisplayIdentifierForPID");
    SBFrontmostApplicationDisplayIdentifier = dlsym(sbserv, "SBFrontmostApplicationDisplayIdentifier");
    SBSCopyLocalizedApplicationNameForDisplayIdentifier  =
    dlsym(sbserv, "SBSCopyLocalizedApplicationNameForDisplayIdentifier");
}

-(NSString*)getTopMostAppBundleId
{
    char topapp[256];
    SBFrontmostApplicationDisplayIdentifier(p,topapp);

    NSString *bundleId=[NSString stringWithFormat:@"%s",topapp];//获取前台运行的app bundle id
   // if (topapp[0] == '\xd8')
    //{
    //    bundleId = @"Desktop";
   // }
    return bundleId;
}

-(NSString*)getAppName:(NSString*)appId
{
    return SBSCopyLocalizedApplicationNameForDisplayIdentifier(appId);
}

-(void)onTimer
{
    preTopMostAppId = currentTopAppId;
    currentTopAppId = [self getTopMostAppBundleId];
    
    NSString *preAppName = [self getAppName:preTopMostAppId];
    
    BOOL isPreValid = [self isAppNameValid:preTopMostAppId];
    BOOL isCurrentValid = [self isAppNameValid:currentTopAppId];
    BOOL isSameId = [self isSame:preTopMostAppId withId:currentTopAppId];
    
 
    if (isPreValid)
    {
        if (isCurrentValid)
        {
            if (isSameId)
            {
                runTime ++;
            }else
            {
                [self insertDataWithAppId:preTopMostAppId andAppName:preAppName andTime:runTime];
                runTime = 0;

            }
        }
        else
        {
            [self insertDataWithAppId:preTopMostAppId andAppName:preAppName andTime:runTime];
            runTime = 0;
        }
    }
    else
    {
        if (isCurrentValid)
        {
            runTime = 0;
        }
    }
    
}

-(BOOL)isAppIdValid:(NSString*)appId
{
    return appId.length > 0;
}

-(BOOL)isAppNameValid:(NSString*)appId
{
    NSString *appName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(appId);
    return appName.length > 0;
}

-(BOOL)isSame:(NSString*)a withId:(NSString*)b
{
    return [a isEqualToString:b];
}


-(void)pauseTimer
{
    [timer setFireDate:[NSDate distantFuture]];
}

-(void)resumeTimer
{
   [timer setFireDate:[NSDate date]];

}

-(void)insertDataWithAppId:(NSString*)appId andAppName:(NSString*)appName andTime:(int)time
{
    
    AppRunInfoItem *itemEntity = [[AppRunInfoItem alloc]init];
    itemEntity.appId = appId;
    itemEntity.appName = appName;
    itemEntity.runTime = [NSNumber numberWithInt:time];
    itemEntity.date =  [[NSDate date]stringWithFormat:[NSDate dateFormatString]];
    [[AppTimeAccess sharedInstance]insertAppRunInfoItem:itemEntity];
}


-(UIImage*)getAppIconImageByBundleId:(NSString*)bundleid
{
    NSData* (*SBSCopyIconImagePNGDataForDisplayIdentifier)(NSString * bundleid) =
    dlsym(sbserv, "SBSCopyIconImagePNGDataForDisplayIdentifier");
    
    UIImage *icon = nil;
    NSData *iconData = SBSCopyIconImagePNGDataForDisplayIdentifier(bundleid);
    if (iconData != nil) {
        icon = [UIImage imageWithData:iconData];
        
    }
    return icon;
}

@end
