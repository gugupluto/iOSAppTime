//
//  StatusViewCell.h
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import <UIKit/UIKit.h>
#import "AppRunInfo.h"

@protocol StatusViewCellDelegate <NSObject>

@optional
-(void)popMenuClicked:(UITableViewCell*)cell withIndex:(int)index;

@end
@interface StatusViewCell : UITableViewCell
{
    UILabel *label  ;
    
    UILabel *labelCount ;
    UILabel *labelTime  ;
    UIImageView *iconView ;
}
@property(nonatomic,unsafe_unretained)id<StatusViewCellDelegate>delegate;
-(void)setAppInfo:(AppRunInfoItem*)appInfo;

@end
