//
//  rightViewController.h
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import <UIKit/UIKit.h>
@class StatusViewController;
@protocol rightViewControllerDelegate <NSObject>

-(void)tableViewDidSelectedWithSection:(int)setion andRow:(int)row;

@end

@interface rightViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property(nonatomic,unsafe_unretained)id<rightViewControllerDelegate> delegate;

@property(nonatomic,retain)StatusViewController *statusController;
@end
