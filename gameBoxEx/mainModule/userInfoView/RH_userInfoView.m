//
//  RH_userInfoView.m
//  lotteryBox
//
//  Created by Lewis on 2017/12/25.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_userInfoView.h"
#import "RH_UserInfoTotalCell.h"
#import "RH_UserInfoGengeralCell.h"
#import "RH_UserInfoManager.h"

@interface RH_userInfoView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) IBOutlet UITableView *tableView ;
@property(nonatomic,strong) IBOutlet UIButton *btnRetrive   ;

@end

@implementation RH_userInfoView
-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.borderWidth = PixelToPoint(1.0f) ;
    self.layer.masksToBounds = YES ;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [self.tableView registerCellWithClass:[RH_UserInfoTotalCell class]] ;
    [self.tableView registerCellWithClass:[RH_UserInfoGengeralCell class]] ;
    
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    
    if ([THEMEV3 isEqualToString:@"green"]){
        self.btnRetrive.backgroundColor = colorWithRGB(35, 119, 214);
    }else if ([THEMEV3 isEqualToString:@"red"]){
         self.btnRetrive.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
        
    }else if ([THEMEV3 isEqualToString:@"black"]){
         self.btnRetrive.backgroundColor = colorWithRGB(35, 119, 214);
        
    }else if ([THEMEV3 isEqualToString:@"blue"]){
        self.btnRetrive.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
        
    }else if ([THEMEV3 isEqualToString:@"orange"]){
        self.btnRetrive.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
        
    }else if ([THEMEV3 isEqualToString:@"red_white"]){
        self.btnRetrive.backgroundColor = RH_NavigationBar_BackgroundColor_Red_White;
    }else if ([THEMEV3 isEqualToString:@"green_white"]){
        self.btnRetrive.backgroundColor = RH_NavigationBar_BackgroundColor_Green_White;
    }else if ([THEMEV3 isEqualToString:@"orange_white"]){
        self.btnRetrive.backgroundColor = RH_NavigationBar_BackgroundColor_Orange_White;
    }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
        self.btnRetrive.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_White;
    }else if ([THEMEV3 isEqualToString:@"coffee_black"]){
        self.btnRetrive.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_Black;
        
    }else{
         self.btnRetrive.backgroundColor = RH_NavigationBar_BackgroundColor;
    }
   
    self.btnRetrive.layer.cornerRadius = 5.0f ;
    [self.btnRetrive setTitleColor:colorWithRGB(239, 239, 239) forState:UIControlStateNormal] ;
    [self.btnRetrive.titleLabel setFont:[UIFont systemFontOfSize:15.0f]] ;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotificatin:)
                                                 name:RHNT_UserInfoManagerMineGroupChangedNotification object:nil] ;
    [self updateUI] ;
}

-(void)updateUI
{
    if (!MineSettingInfo.mIsAutoPay) {
        [self.btnRetrive setTitle:@"一键刷新" forState:UIControlStateNormal];
    }else
    {
        [self.btnRetrive setTitle:@"一键回收" forState:UIControlStateNormal];
    }
    [self.tableView reloadData] ;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

#pragma mark-
-(void)handleNotificatin:(NSNotification*)nt
{
    if ([nt.name isEqualToString:RHNT_UserInfoManagerMineGroupChangedNotification]){
        [self performSelectorOnMainThread:@selector(updateUI) withObject:self waitUntilDone:NO] ;
    }
}

#pragma mark-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) return 1 ;
    return MineSettingInfo.mApisBalanceList.count ; 
}



-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return  [RH_UserInfoTotalCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
    }else{
        return [RH_UserInfoGengeralCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        RH_UserInfoTotalCell *userInfoTotalCell = [tableView dequeueReusableCellWithIdentifier:[RH_UserInfoTotalCell defaultReuseIdentifier]] ;
        [userInfoTotalCell updateCellWithInfo:nil context:MineSettingInfo] ;
//        [userInfoTotalCell updateCellWithInfo:nil context:GetUseAssertInfo] ;
        return userInfoTotalCell ;
    }else{
        RH_UserInfoGengeralCell *userInfoGeneralCell = [tableView dequeueReusableCellWithIdentifier:[RH_UserInfoGengeralCell defaultReuseIdentifier]] ;
        if (indexPath.item < MineSettingInfo.mApisBalanceList.count){
            [userInfoGeneralCell updateCellWithInfo:nil context:MineSettingInfo.mApisBalanceList[indexPath.item]] ;
            RH_UserApiBalanceModel *model = MineSettingInfo.mApisBalanceList[indexPath.item] ;
            
            NSInteger index = (NSInteger)(indexPath.row/+1)%2;
            [model setIndex:index];
            if (index == 1) {
                userInfoGeneralCell.contentView.backgroundColor = colorWithRGB(95, 100, 104);
            }
        }
        return userInfoGeneralCell ;
    }
}

#pragma mark -  一键回收点击方法
-(IBAction)btn_oneStepRecover:(id)sender
{
    if (!MineSettingInfo.mIsAutoPay) {
        ifRespondsSelector(self.delegate, @selector(userInfoViewDidTouchOneStepRefreshButton:)){
            [self.delegate userInfoViewDidTouchOneStepRefreshButton:self] ;
        }
    }else
    {
        ifRespondsSelector(self.delegate, @selector(userInfoViewDidTouchOneStepRecoryButton:)){
            [self.delegate userInfoViewDidTouchOneStepRecoryButton:self] ;
        }
    }
   
}

-(IBAction)btn_Deposit:(id)sender
{
    ifRespondsSelector(self.delegate, @selector(userInfoViewDidTouchOneStepDepositeButton:)){
        [self.delegate userInfoViewDidTouchOneStepDepositeButton:self] ;
    }
}

@end
