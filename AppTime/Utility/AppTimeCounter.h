//
//  AppTimeCounter.h
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import <Foundation/Foundation.h>
@interface AppTimeCounter : NSObject
{
    mach_port_t *p;
    void *uikit;
    int (*SBSSpringBoardServerPort)();
    void *sbserv;
    NSArray* (*SBSCopyApplicationDisplayIdentifiers)(mach_port_t* port, BOOL runningApps,BOOL debuggablet);
    void* (*SBDisplayIdentifierForPID)(mach_port_t* port, int pid,char * result);
    void* (*SBFrontmostApplicationDisplayIdentifier)(mach_port_t* port,char * result);
    NSString * (*SBSCopyLocalizedApplicationNameForDisplayIdentifier)(NSString* );
    NSString * topAppBundleId;
 
    
    NSDate *dateForTopmostApp;
    
    NSTimer *timer;
    NSString *preTopMostAppId;
    NSString *currentTopAppId;
    
    int runTime;
    
}
+(AppTimeCounter*)sharedInstance;
-(NSString*)getTopMostAppBundleId;
-(void)pauseTimer;
-(void)resumeTimer;
-(UIImage*)getAppIconImageByBundleId:(NSString*)bundleid;
@end

