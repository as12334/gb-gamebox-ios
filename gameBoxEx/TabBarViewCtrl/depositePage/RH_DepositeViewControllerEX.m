//
//  RH_DepositeViewControllerEX.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/21.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeViewControllerEX.h"

@interface RH_DepositeViewControllerEX ()

@end

@implementation RH_DepositeViewControllerEX
-(BOOL)tabBarHidden
{
    return NO ;
}
-(BOOL)needLogin
{
    return YES  ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
    
    [self setupUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    
}
#pragma mark --检测是否登录
-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        [self updateView] ;
    }
}
-(void)updateView
{
    if (self.appDelegate.isLogin&&NetworkAvailable()){
        
    }
    else if(!self.appDelegate.isLogin){
        //进入登录界面
        [self loginButtonItemHandle] ;
    }
    else if (NetNotReachability()){
        showAlertView(@"无网络", @"") ;
    }
}
#pragma mark --视图
-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    [self.contentView addSubview:self.contentTableView] ;
}
#pragma mark-tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return  10 ;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.loadingIndicateTableViewCell ;
  
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section==1){
//        RH_HomePageModel *homePageModel = ConvertToClassPointer(RH_HomePageModel, [self.pageLoadManager dataAtIndex:0]) ;
//        if (self.rhAlertView.superview == nil) {
//            self.rhAlertView = [RH_BasicAlertView createInstance];
//            self.rhAlertView.alpha = 0;
//            [self.view.window addSubview:self.rhAlertView];
//            self.rhAlertView.whc_TopSpace(0).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                self.rhAlertView.alpha = 1;
//            } completion:^(BOOL finished) {
//                if (finished) {
//                    [self.rhAlertView showContentWith:homePageModel.mAnnouncementList];
//                    
//                }
//            }];
//        }
//    }
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

@end
