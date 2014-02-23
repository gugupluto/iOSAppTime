//
//  StatusViewCell.m
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import "StatusViewCell.h"
#import "AppRunInfo.h"
#import "AppTimeCounter.h"
#define kTagLabel 100
#define kTagLabelCount 105
#define kTagLabelTime 110
#define kTagImg  200
#define kTagSwitch 300
@implementation StatusViewCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
     
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = NO;
        
            label  = [[UILabel alloc] initWithFrame:CGRectMake(64, 10, 150, 20)];
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont boldSystemFontOfSize:15];
            label.textColor = [UIColor blackColor];
            label.tag = kTagLabel;
            [self.contentView addSubview:label];
            
            UILabel *labelCountTitle  = [[UILabel alloc] initWithFrame:CGRectMake(64, 35,80, 20)];
            labelCountTitle.backgroundColor = [UIColor clearColor];
            labelCountTitle.font = [UIFont systemFontOfSize:13];
            labelCountTitle.textColor = [UIColor grayColor];
            labelCountTitle.text = @"打开次数:";
            [self.contentView addSubview:labelCountTitle];
            
            labelCount  = [[UILabel alloc] initWithFrame:CGRectMake(124, 35, 40, 20)];
            labelCount.backgroundColor = [UIColor clearColor];
            labelCount.font = [UIFont systemFontOfSize:13];
            labelCount.textColor = [UIColor grayColor];
            labelCount.tag = kTagLabelCount;
            
            [self.contentView addSubview:labelCount];
            
            UILabel *labelTimeTitle  = [[UILabel alloc] initWithFrame:CGRectMake(64, 50,80, 20)];
            labelTimeTitle.backgroundColor = [UIColor clearColor];
            labelTimeTitle.font = [UIFont systemFontOfSize:13];
            labelTimeTitle.textColor = [UIColor grayColor];
            labelTimeTitle.text = @"使用时长:";
            [self.contentView addSubview:labelTimeTitle];
            
            labelTime  = [[UILabel alloc] initWithFrame:CGRectMake(124, 50, 90, 20)];
            labelTime.backgroundColor = [UIColor clearColor];
            labelTime.font = [UIFont systemFontOfSize:13];
            labelTime.textColor = [UIColor grayColor];
            labelTime.tag = kTagLabelTime;
            [self.contentView addSubview:labelTime];
            
            
            
            iconView = [[UIImageView alloc]initWithFrame:CGRectMake(150, 8, 45, 45)];
            iconView.tag = kTagImg;
            [self.contentView addSubview:iconView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
  

    // Configure the view for the selected state
}

-(void)setAppInfo:(AppRunInfoItem*)appInfo
{
 
    
    label.text = appInfo.appName;
    iconView.image = [[AppTimeCounter sharedInstance]getAppIconImageByBundleId:appInfo.appId];
    labelCount.text =[NSString stringWithFormat:@"%d次",appInfo.count];
    iconView.hidden = NO;
    iconView.frame = CGRectMake(10, 8, 45, 45);
    label.frame = CGRectMake(64, 10, 120, 20);
    NSString *timeString = @"";
    
    int time = appInfo.runTime.intValue;
    if (time >= 0 && time < 60)
    {
        timeString = [NSString stringWithFormat:@"%d秒",time];
    }
    else if (time >=60 && time < 3600)
    {
        timeString = [NSString stringWithFormat:@"%d分%d秒",time / 60, time % 60];
    }
    else if (time >3600)
    {
        timeString = [NSString stringWithFormat:@"%d小时%d分",time / 3600, (time % 3600) / 60 ];
    }
    else if (time >86400)
    {
        timeString = [NSString stringWithFormat:@"%d天%d小时",time/ 86400, (time % 3600) ];
    }

        labelTime.text = timeString;
}

@end
