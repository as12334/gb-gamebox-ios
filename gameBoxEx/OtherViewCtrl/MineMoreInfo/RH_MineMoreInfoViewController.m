//
//  RH_MineMoreInfoViewController.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_MineMoreInfoViewController.h"

@interface RH_MineMoreInfoViewController ()<CLTableViewManagementDelegate>
@property(nonatomic,strong,readonly) CLTableViewManagement *tableViewManagement ;
@end

@implementation RH_MineMoreInfoViewController
@synthesize tableViewManagement = _tableViewManagement   ;
- (BOOL)isSubViewController {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更多" ;
    [self setupInfo];
}
#pragma mark-
-(void)setupInfo
{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO] ;
    [self.contentView addSubview:self.contentTableView] ;
    [self.tableViewManagement reloadData] ;
}

-(CLTableViewManagement*)tableViewManagement
{
    if (!_tableViewManagement){
        _tableViewManagement = [[CLTableViewManagement alloc] initWithTableView:self.contentTableView
                                                              configureFileName:@"RH_MineMoreCells"
                                                                         bundle:nil] ;
        
        _tableViewManagement.delegate = self ;
    }
    
    return _tableViewManagement ;
}
-(BOOL)tableViewManagement:(CLTableViewManagement *)tableViewManagement didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.section==0&&indexPath.item==0) {
//        RH_SetAccountMeanViewController *accoungt = [[RH_SetAccountMeanViewController alloc]init];
//        [self.navigationController pushViewController:accoungt animated:YES];
//    }
//    else if (indexPath.section==0&&indexPath.item==1) {
//        RH_SetPushMessageController *pushMessage = [[RH_SetPushMessageController alloc]init];
//        [self.navigationController pushViewController:pushMessage animated:YES];
//    }
    
    return YES;
}
@end
