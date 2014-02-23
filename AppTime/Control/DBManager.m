//
//  DBManager.m
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime


#import "DBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"

const NSString *DB_NAME = @"BDCOOL";

@implementation DBManager

+ (DBManager *)shareDBManager{
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager = [[DBManager alloc] init];
    });
    return manager;
}

- (void)initTable{
    NSArray *createTableSqls = [NSArray arrayWithObjects:
                                @"CREATE TABLE AppRunInfo (appId VARCHAR ,appName char, runTime integer,date char)"
                                
                                ,
                                @"CREATE TABLE FilterApp (appId VARCHAR)"
                                
                                ,nil];
    
    
    [db open];
    [db beginTransaction];
    for(NSString *sql in createTableSqls){
        if(![db executeUpdate:sql]){
            [db rollback];
            break;
        }
    }
    [db commit];
    [db close];
}

- (id)init{
    self = [super init];
    if(self){
        NSString *documentsDir = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *tmpPath = [documentsDir stringByAppendingPathComponent:@"AppTime.sqlite"];
        //  NSString *tmpPath = @"/Users/zc/AppTime.sqlite";
		if (![[NSFileManager defaultManager] fileExistsAtPath:tmpPath]){
			db = [[FMDatabase alloc] initWithPath:tmpPath];
			[self initTable];
		}else {
			db = [[FMDatabase alloc] initWithPath:tmpPath];
		}
        
    }
    return self;
}


- (BOOL)openDB{
    return [db open];
}
- (BOOL)closeDB{
    return [db close];
}
- (BOOL)insertData:(id)data toTable:(NSString *)name{
    @synchronized (self){
        if ([data isKindOfClass:[NSDictionary class]]){
            [db open];
            
            NSMutableArray *s = [[NSMutableArray alloc] init];
            for (id value in [data allValues]){
                [s addObject:@"?"];
            }
            NSString *sql = [[NSString alloc] initWithFormat:@"INSERT OR REPLACE into %@ (%@) values (%@)", name, [[data allKeys] componentsJoinedByString:@","], [s componentsJoinedByString:@","]];
            BOOL result = [db executeUpdate:sql withArgumentsInArray:[data allValues]];
            [db close];
            return  result;
        }else {
            [db open];
            for (NSMutableDictionary *_data in data){
                NSMutableArray *s = [[NSMutableArray alloc] init];
                for (id value in [_data allValues]){
                    [s addObject:@"?"];
                }
                
                NSString *sql = [[NSString alloc] initWithFormat:@"INSERT OR REPLACE into %@ (%@) values (%@)", name, [[_data allKeys] componentsJoinedByString:@","], [s componentsJoinedByString:@","]];
                
                if (![db executeUpdate:sql withArgumentsInArray:[_data allValues]]){
                NSLog(@"error");
                }
            }
            [db close];
            
            return YES;
        }
        return  NO;
    }
    
    
}

- (NSMutableArray*)executeSqlWithResult:(NSString *)sql{
	@synchronized (self){
        NSMutableArray *result = [NSMutableArray array];
        [db open];
        FMResultSet *rs = [db executeQuery:sql];
        if (rs){
            while ([rs next]) {
                [result addObject:[rs resultDictionary]];
            }
        }
        [db close];
        return  result;
    }
}

@end

