//
//  StatusViewController.h
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import <UIKit/UIKit.h>
#import "StatusViewCell.h"
#import "rightViewController.h"
typedef enum {
    CATE_COUNT,
    CATE_TIME,
    CATE_AVETIME
} CATEGORY;

typedef enum {
    DES,
    ASC
} ORDER;
@class QBPopupMenu;
@interface StatusViewController:UIViewController<UITableViewDataSource,UITableViewDelegate,StatusViewCellDelegate,rightViewControllerDelegate>
{
    UITableView *statusTable;
    NSMutableArray *appInfoDatasource;
    int  currentIndex;
    
    BOOL isFilter;
}

-(void)refresh;
@property(nonatomic,assign)CATEGORY category;
@property(nonatomic,assign)ORDER order;
@end
