//
//  AppTimeAccess.h
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import <Foundation/Foundation.h>
#import "AppRunInfo.h"
@interface AppTimeAccess : NSObject

+ (AppTimeAccess *)sharedInstance;

-(void)insertAppRunInfoItem:(AppRunInfoItem*)itemEntity;
-(NSArray*)readAllRecords;
-(NSArray*)readAllRecordsByDate:(NSDate*)date;
-(NSArray*)readAllRecordsGroupByAppId;
-(void)insertFilterAppById:(NSString*)appId;
-(NSArray*)readAllFilterApp;
-(NSArray*)readThisWeekRescordsByDate;
@end
