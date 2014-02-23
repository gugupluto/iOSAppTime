//
//  StatusViewController.m
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import "StatusViewController.h"
#import "AppTimeCounter.h"
#import "AppTimeAccess.h"
#import "AppDelegate.h"
#import "StatusViewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "rightViewController.h"
#define k_tag_leftButton               829001
#define k_tag_rightButton              829002
#define kTagLabel 100
#define kTagLabelCount 105
#define kTagLabelTime 110
#define kTagImg  200
#define kTagSwitch 300
@interface StatusViewController ()

@end

@implementation StatusViewController
@synthesize order;
@synthesize category;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
           self.title = @"使用时间统计";
 
 
         appInfoDatasource = [[NSMutableArray alloc]init];
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"今日",@"本周",@"全部", nil]];
        segment.selectedSegmentIndex = 0;
        
       
        segment.frame  = CGRectMake(10, 65, 300, 30);
        [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
 
        [self.view addSubview:segment];
        
        statusTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, self.view.frame.size.height-95) style:UITableViewStylePlain];
        statusTable.delegate = self;
        statusTable.dataSource = self;
        statusTable.scrollsToTop = NO;

        
        statusTable.backgroundColor = [UIColor colorWithRed:229.0/256.0 green:229.0/256.0 blue:229.0/256.0 alpha:1.0];
        [self.view addSubview:statusTable];
    
 
        UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.frame = CGRectMake(0, 0, 30, 30);
        [rightButton setTitle:@"排序" forState:UIControlStateNormal];
 
        [rightButton addTarget:self action:@selector(onClickRighButton:)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
 
        self.navigationItem.rightBarButtonItem= rightItem;
  
  
        order = DES;
        category = CATE_COUNT;
    }
    return self;
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    currentIndex = (int)Index;
     [self refresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    
    [appInfoDatasource removeAllObjects];
    NSArray *array = [[AppTimeAccess sharedInstance]readAllRecordsByDate:[NSDate date]];
    [appInfoDatasource addObjectsFromArray:array];
    [statusTable reloadData];
    
  
    
 
  	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return appInfoDatasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *CellIdentifier = @"StatusTableViewCell";
    StatusViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
    if (!cell)
    {
        cell = [[StatusViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
                cell.delegate = self;
    }
   
    [cell setAppInfo:[appInfoDatasource objectAtIndex:[indexPath row] ]];
    return cell;
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refresh];
   
}

-(void)sort
{
    if (order == ASC && category == CATE_COUNT)
    {
        [self sortByCountAsc];
    }
    if (order == DES && category == CATE_COUNT)
    {
        [self sortByCountDes];
    }
    if (order == ASC && category == CATE_TIME)
    {
        [self sortByTimeAsc];
    }
    if (order == DES && category == CATE_TIME)
    {
        [self sortByTimeDes];
    }
    if (order == ASC && category == CATE_AVETIME)
    {
        [self sortByTimePerCountAsc];
    }
    if (order == DES && category == CATE_AVETIME)
    {
        [self sortByTimePerCountDes];
    }
}

-(void)refresh
{
     [appInfoDatasource removeAllObjects];
    if (currentIndex == 0)
    {
        NSArray *array = [[AppTimeAccess sharedInstance]readAllRecordsByDate:[NSDate date]];
        [appInfoDatasource addObjectsFromArray:array];
    }
    else if (currentIndex == 1)
    {
        NSArray *array =   [[AppTimeAccess sharedInstance]readThisWeekRescordsByDate];
         [appInfoDatasource addObjectsFromArray:array];
    }
    else
    {
        NSArray *array = [[AppTimeAccess sharedInstance]readAllRecordsGroupByAppId];
        [appInfoDatasource addObjectsFromArray:array];
    }
   
    [self sort];

    [statusTable reloadData];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  75;
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)onClickRighButton:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished){}];
}

-(void)sortByCountAsc
{
    [appInfoDatasource sortUsingComparator:^(id obj1,id obj2)
     {
         AppRunInfoItem *info1 = (AppRunInfoItem*)obj1;
         AppRunInfoItem *info2 = (AppRunInfoItem*)obj2;
         if (info1.count  > info2.count ) {
             return (NSComparisonResult)NSOrderedDescending;
         }
         
         if (info1.count   < info2.count) {
             return (NSComparisonResult)NSOrderedAscending;
         }
         return (NSComparisonResult)NSOrderedSame;
     }
     ];

}

-(void)sortByCountDes
{
    [appInfoDatasource sortUsingComparator:^(id obj1,id obj2)
     {
         AppRunInfoItem *info1 = (AppRunInfoItem*)obj1;
         AppRunInfoItem *info2 = (AppRunInfoItem*)obj2;
         if (info1.count  > info2.count ) {
             return (NSComparisonResult)NSOrderedAscending;
         }
         
         if (info1.count   < info2.count) {
             return (NSComparisonResult)NSOrderedDescending;
         }
         return (NSComparisonResult)NSOrderedSame;
     }
     ];
}

-(void)sortByTimeAsc
{
    [appInfoDatasource sortUsingComparator:^(id obj1,id obj2)
     {
         AppRunInfoItem *info1 = (AppRunInfoItem*)obj1;
         AppRunInfoItem *info2 = (AppRunInfoItem*)obj2;
         if (info1.runTime .intValue > info2.runTime.intValue ) {
             return (NSComparisonResult)NSOrderedDescending;
         }
         
         if (info1.runTime.intValue   < info2.runTime.intValue) {
             return (NSComparisonResult)NSOrderedAscending;
         }
         return (NSComparisonResult)NSOrderedSame;
     }
     ];
}

-(void)sortByTimeDes
{
    [appInfoDatasource sortUsingComparator:^(id obj1,id obj2)
     {
         AppRunInfoItem *info1 = (AppRunInfoItem*)obj1;
         AppRunInfoItem *info2 = (AppRunInfoItem*)obj2;
         if (info1.runTime.intValue  > info2.runTime.intValue ) {
             return (NSComparisonResult)NSOrderedAscending;
         }
         
         if (info1.runTime.intValue   < info2.runTime.intValue) {
             return (NSComparisonResult)NSOrderedDescending;
         }
         return (NSComparisonResult)NSOrderedSame;
     }
     ];
}
-(void)sortByTimePerCountDes
{
    [appInfoDatasource sortUsingComparator:^(id obj1,id obj2)
     {
         AppRunInfoItem *info1 = (AppRunInfoItem*)obj1;
         AppRunInfoItem *info2 = (AppRunInfoItem*)obj2;
         float timePerCount1 = info1.runTime.intValue / info1.count;
         float timePerCount2 = info2.runTime.intValue / info2.count;
         
         if (timePerCount1  > timePerCount2 ) {
             return (NSComparisonResult)NSOrderedAscending;
         }
         
         if (timePerCount1   < timePerCount2) {
             return (NSComparisonResult)NSOrderedDescending;
         }
         return (NSComparisonResult)NSOrderedSame;
     }
     ];
}

-(void)sortByTimePerCountAsc
{
    [appInfoDatasource sortUsingComparator:^(id obj1,id obj2)
     {
         AppRunInfoItem *info1 = (AppRunInfoItem*)obj1;
         AppRunInfoItem *info2 = (AppRunInfoItem*)obj2;
         float timePerCount1 = info1.runTime.intValue / info1.count;
         float timePerCount2 = info2.runTime.intValue / info2.count;
         
         if (timePerCount1  > timePerCount2 ) {
             return (NSComparisonResult)NSOrderedDescending;
         }
         
         if (timePerCount1   < timePerCount2) {
             return (NSComparisonResult)NSOrderedAscending;
         }
         return (NSComparisonResult)NSOrderedSame;
     }
     ];
}


-(void)tableViewDidSelectedWithSection:(int)section andRow:(int)row
{
    if (section == 0)
    {
        if (row == 0)
        {
            order = DES;
        }
        else
        {
            order = ASC;
        }
    }
    else{
        if (row == 0) {
            category = CATE_COUNT;
        }
        else   if (row == 1) {
            category = CATE_TIME;
        }
        else
        {
            category = CATE_AVETIME;
        }
    }
    [self refresh];
}
@end
