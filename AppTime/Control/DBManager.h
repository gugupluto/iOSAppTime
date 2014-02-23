//
//  DBManager.h
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import <Foundation/Foundation.h>
@class FMDatabase;
const NSString *DB_NAME;

@interface DBManager : NSObject{
    NSString * TAG;
	int		DB_VERSION;
    FMDatabase *db;
}
+ (DBManager *)shareDBManager;
- (BOOL)openDB;
- (BOOL)closeDB;
- (BOOL)insertData:(id)data toTable:(NSString *)name;
- (NSMutableArray*)executeSqlWithResult:(NSString *)sql;

@end

