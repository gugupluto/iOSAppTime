//
//  AppTimeAccess.m
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import "AppTimeAccess.h"

#import "DBManager.h"
#import "NSDate+Helper.h"
@implementation AppTimeAccess
#define TABLENAME @"AppRunInfo"
#define FILTER @"FilterApp"
+ (AppTimeAccess *)sharedInstance
{
    static AppTimeAccess *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager = [[AppTimeAccess alloc] init];
    });
    return manager;
}

- (id)init{
    self = [super init];
    if(self){

        
    }
    return self;
}

-(void)insertAppRunInfoItem:(AppRunInfoItem*)itemEntity
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:itemEntity.appId forKey:@"appId"];
    [dict setObject:itemEntity.appName forKey:@"appName"];
    [dict setObject:itemEntity.runTime forKey:@"runTime"];
    [dict setObject:itemEntity.date forKey:@"date"];
    
    [[DBManager shareDBManager]insertData:dict toTable:TABLENAME];
    
}

-(void)insertFilterAppById:(NSString*)appId
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:appId forKey:@"appId"];

    
    [[DBManager shareDBManager]insertData:dict toTable:FILTER];
    
}


-(NSArray*)readAllRecords
{

    NSString *sql = @"select * from AppRunInfo where appId not in (select * from FilterApp)";
   NSMutableArray *records = [[DBManager shareDBManager]executeSqlWithResult:sql];
    NSMutableArray *entityArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in records)
    {
        AppRunInfoItem *itemEntity = [[AppRunInfoItem alloc]init];
        itemEntity.appId = [dict objectForKey:@"appId"];
        itemEntity.appName = [dict objectForKey:@"appName"];
        itemEntity.runTime = [dict objectForKey:@"runTime"];
        itemEntity.date = [dict objectForKey:@"date"];
        [entityArray addObject:itemEntity];
        
    }
    return entityArray;
}



-(NSArray*)readAllRecordsByDate:(NSDate*)date
{
    NSString *datestring = [date stringWithFormat:[NSDate dateFormatString]];
    
     NSString *sql = [NSString stringWithFormat:@"select appId,appName,sum(runTime) as runTime,date ,count(appId) as count from AppRunInfo  where date='%@'  and appId not in (select * from FilterApp)group by appId ",datestring ];
    
        NSMutableArray *records = [[DBManager shareDBManager]executeSqlWithResult:sql];
    NSMutableArray *entityArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in records)
    {
        AppRunInfoItem *itemEntity = [[AppRunInfoItem alloc]init];
        itemEntity.appId = [dict objectForKey:@"appId"];
        itemEntity.appName = [dict objectForKey:@"appName"];
        itemEntity.runTime = [dict objectForKey:@"runTime"];
        itemEntity.date = [dict objectForKey:@"date"];
        itemEntity.count = [[dict objectForKey:@"count"]intValue];
        [entityArray addObject:itemEntity];
        
    }
    return entityArray;
}

-(NSArray*)readThisWeekRescordsByDate
{
 
    int weekday = [NSDate getWeekDay];
    int days = 0;
    if (weekday == 1)
    {
        days = 6;
    }
    else
    {
        days = weekday - 2;
    }
    
    NSDate *previousDate = [NSDate dateBeforeDate:days];
    NSString *sql = [NSString stringWithFormat:@"select appId,appName,sum(runTime) as runTime,date,count(appId) as count from AppRunInfo where appId not in (select * from FilterApp) and date between '%@' and '%@'   group by appId ",[previousDate stringWithFormat:[NSDate dateFormatString]],[[NSDate date]stringWithFormat:[NSDate dateFormatString]] ];
    NSMutableArray *records = [[DBManager shareDBManager]executeSqlWithResult:sql];
    NSMutableArray *entityArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in records)
    {
        AppRunInfoItem *itemEntity = [[AppRunInfoItem alloc]init];
        itemEntity.appId = [dict objectForKey:@"appId"];
        itemEntity.appName = [dict objectForKey:@"appName"];
        itemEntity.runTime = [dict objectForKey:@"runTime"];
        itemEntity.date = [dict objectForKey:@"date"];
        itemEntity.count = [[dict objectForKey:@"count"]intValue];
        [entityArray addObject:itemEntity];
        
    }
    return entityArray;
 
 
}

-(NSArray*)readAllRecordsGroupByAppId
{
    NSString *sql = [NSString stringWithFormat:@"select appId,appName,sum(runTime) as runTime,date,count(appId) as count from AppRunInfo where appId not in (select * from FilterApp)  group by appId " ];
    NSMutableArray *records = [[DBManager shareDBManager]executeSqlWithResult:sql];
    NSMutableArray *entityArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in records)
    {
        AppRunInfoItem *itemEntity = [[AppRunInfoItem alloc]init];
        itemEntity.appId = [dict objectForKey:@"appId"];
        itemEntity.appName = [dict objectForKey:@"appName"];
        itemEntity.runTime = [dict objectForKey:@"runTime"];
        itemEntity.date = [dict objectForKey:@"date"];
        itemEntity.count = [[dict objectForKey:@"count"]intValue];
        [entityArray addObject:itemEntity];
        
    }
    return entityArray;
}

-(NSArray*)readAllFilterApp
{
    NSString *sql = [NSString stringWithFormat:@"select appId,appName,sum(runTime) as runTime,date,count(appId) as count from AppRunInfo where appId in (select * from FilterApp)  group by appId " ];
    NSMutableArray *records = [[DBManager shareDBManager]executeSqlWithResult:sql];
    NSMutableArray *entityArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in records)
    {
        AppRunInfoItem *itemEntity = [[AppRunInfoItem alloc]init];
        itemEntity.appId = [dict objectForKey:@"appId"];
        itemEntity.appName = [dict objectForKey:@"appName"];
        itemEntity.runTime = [dict objectForKey:@"runTime"];
        itemEntity.date = [dict objectForKey:@"date"];
        itemEntity.count = [[dict objectForKey:@"count"]intValue];
        [entityArray addObject:itemEntity];
        
    }
    return entityArray;
}


@end
