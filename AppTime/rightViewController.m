//
//  rightViewController.m
//  AppTime
//
//  Created by gugupluto on 14-2-23.
//  Copyright (c) 2013年 gugupluto. All rights reserved.
//  http://www.cnblogs.com/gugupluto
//  https://github.com/gugupluto/iOSAppTime

#import "rightViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "StatusViewController.h"
@interface rightViewController ()
{
    NSArray *orderArray;
    NSArray *cateArray;
}
@end

@implementation rightViewController
@synthesize tableView = _tableView;
@synthesize delegate;
@synthesize statusController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    
    int y = 0;
    NSString * tmpVersonType = [UIDevice currentDevice].systemVersion;
    NSArray * tmpArr = [tmpVersonType componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    if([[tmpArr objectAtIndex:0] isEqualToString:@"7"])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        y = 70;
    }
    CGRect rc = self.view.bounds;
    rc.origin.y = y;
    _tableView = [[UITableView alloc] initWithFrame:rc style:UITableViewStyleGrouped];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
 
    orderArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:DES],[NSNumber numberWithInt:ASC], nil];
    
   cateArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:CATE_COUNT],[NSNumber numberWithInt:CATE_TIME],[NSNumber numberWithInt:CATE_AVETIME], nil];
    
 
    
   

	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 3;
        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    
    
    if (indexPath.section == 0)
    {
         NSNumber *order = [orderArray objectAtIndex:indexPath.row];
        if(indexPath.row == 0){
            [cell.textLabel setText:@"降序"];
        }
        else {
            [cell.textLabel setText:@"升序"];
        }
        
        if (order.intValue == self.statusController.order) {
            
            
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else  [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else
    {
  NSNumber *cate = [cateArray objectAtIndex:indexPath.row];
        if(indexPath.row == 0){
            [cell.textLabel setText:@"打开次数"];
        }
        else if(indexPath.row == 1){
            [cell.textLabel setText:@"使用时长"];
        }
        else if(indexPath.row == 2){
            [cell.textLabel setText:@"每次平均使用时长"];
        }
        if (cate.intValue == self.statusController.category) {
            
            
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else  [cell setAccessoryType:UITableViewCellAccessoryNone];

    }
       return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"顺序";
        case 1:
            return @"类别";
        default:
            return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 23.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (delegate != nil && [delegate respondsToSelector:@selector(tableViewDidSelectedWithSection:andRow: )])
    {
        [delegate tableViewDidSelectedWithSection:indexPath.section andRow:indexPath.row];
    }
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished){}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
