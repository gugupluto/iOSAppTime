//
//  AppRunInfo.h
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import <Foundation/Foundation.h>

@interface AppRunInfoItem : NSObject
@property(nonatomic,retain)NSString *appName;
@property(nonatomic,retain)NSNumber *runTime;
@property(nonatomic,retain)NSString *date;
@property(nonatomic,retain)NSString *appId;
@property(nonatomic,assign)int count;
@end
