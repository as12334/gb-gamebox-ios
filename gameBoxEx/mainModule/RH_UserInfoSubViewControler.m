//
//  RH_UserInfoSubViewControler.m
//  gameBoxEx
//
//  Created by luis on 2017/12/24.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_UserInfoSubViewControler.h"
#import "coreLib.h"
#import "RH_NaviUserInfoTableCell.h"

#define tableViewWidth                                               150.0f
#define tableViewHeight                                              200.0f

@interface RH_UserInfoSubViewControler ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RH_UserInfoSubViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    RH_BasicViewController *parentViewCtrl = ConvertToClassPointer(RH_BasicViewController, self.parentViewController) ;
    self.hiddenTabBar = parentViewCtrl.hiddenTabBar ;
    self.hiddenNavigationBar = YES ;
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.view.backgroundColor = [UIColor clearColor] ;
    [self setupUI] ;
    
    self.needObserverTapGesture = YES ;
}

-(void)setupUI
{
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.contentView.frameWidth - tableViewWidth,
                                                                          StatusBarHeight+NavigationBarHeight + 20,
                                                                          tableViewWidth,
                                                                          tableViewHeight)
                                                         style:UITableViewStylePlain] ;
    
    self.contentTableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin ;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.contentTableView.backgroundColor = RH_Line_DefaultColor ;
    [self.contentTableView addSubview:self.updateRefreshCtrl] ;
    [self.contentTableView registerCellWithClass:[RH_NaviUserInfoTableCell class]] ;
    
    [self.contentView addSubview:self.contentTableView] ;
    self.contentTableView.delegate = self ;
    self.contentTableView.dataSource = self ;
    [self.contentTableView reloadData] ;
}

#pragma -
-(void)tapGestureRecognizerHandle:(UITapGestureRecognizer*)tapGestureRecognizer
{
    //移除显示
    [self beginAppearanceTransition:YES animated:YES];
    [self.view removeFromSuperview];
    [self endAppearanceTransition];
    [self removeFromParentViewController] ;
}

#pragma mark-
-(void)startUpdateHandle
{
    if (NetworkAvailable()){
//        [self.serviceRequest startGetTaskDetailByTaskID:self.taskInfo.mTaskID UserID:[RH_UserManager shareUserManager].userID] ;
        [self.updateRefreshCtrl endRefreshing] ;
    }else{
        [self.contentLoadingIndicateView hiddenView] ;
        [self.updateRefreshCtrl endRefreshing] ;
//        if (self.taskDetail){
//            showAlertView(@"无网络", nil) ;
//        }else{
//            [self.contentLoadingIndicateView showNoNetworkStatus] ;
//        }
    }
}


#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RH_NaviUserInfoTableCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //生成实例
    RH_NaviUserInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_NaviUserInfoTableCell defaultReuseIdentifier] forIndexPath:indexPath] ;
    
    [cell updateCellWithInfo:nil context:nil] ;
    
    return cell ;
}


@end
