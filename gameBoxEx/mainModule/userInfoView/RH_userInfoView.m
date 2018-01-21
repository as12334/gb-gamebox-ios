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
@property(nonatomic,strong) IBOutlet UIButton *btnSave      ;

@end

@implementation RH_userInfoView
-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.borderMask = CLBorderMarkAll ;
    self.borderColor = colorWithRGB(204, 204, 204) ;
    self.borderWidth = PixelToPoint(1.0f) ;
    self.layer.masksToBounds = YES ;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    [self.tableView registerCellWithClass:[RH_UserInfoTotalCell class]] ;
    [self.tableView registerCellWithClass:[RH_UserInfoGengeralCell class]] ;
    
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    
    self.btnRetrive.backgroundColor = colorWithRGB(27, 117, 217) ;
    self.btnRetrive.layer.cornerRadius = 5.0f ;
    [self.btnRetrive setTitleColor:colorWithRGB(239, 239, 239) forState:UIControlStateNormal] ;
    [self.btnRetrive.titleLabel setFont:[UIFont systemFontOfSize:15.0f]] ;
    
    self.btnSave.backgroundColor = colorWithRGB(14, 195, 146) ;
    self.btnSave.layer.cornerRadius = 5.0f ;
    [self.btnSave setTitleColor:colorWithRGB(239, 239, 239) forState:UIControlStateNormal] ;
    [self.btnSave.titleLabel setFont:[UIFont systemFontOfSize:15.0f]] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotificatin:)
                                                 name:RHNT_UserInfoManagerBalanceChangedNotification object:nil] ;
    [self updateUI] ;
}

-(void)updateUI
{
    [self.tableView reloadData] ;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

#pragma mark-
-(void)handleNotificatin:(NSNotification*)nt
{
    if ([nt.name isEqualToString:RHNT_UserInfoManagerBalanceChangedNotification]){
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
    return UserBalanceInfo.mApis.count ;
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
        [userInfoTotalCell updateCellWithInfo:nil context:UserBalanceInfo] ;
        return userInfoTotalCell ;
    }else{
        RH_UserInfoGengeralCell *userInfoGeneralCell = [tableView dequeueReusableCellWithIdentifier:[RH_UserInfoGengeralCell defaultReuseIdentifier]] ;
        if (indexPath.item < UserBalanceInfo.mApis.count){
            [userInfoGeneralCell updateCellWithInfo:nil context:UserBalanceInfo.mApis[indexPath.item]] ;
        }
        return userInfoGeneralCell ;
    }
}

#pragma mark -  一键回收点击方法
-(IBAction)btn_oneStepRecover:(id)sender
{
    ifRespondsSelector(self.delegate, @selector(userInfoViewDidTouchOneStepRecoryButton:)){
        [self.delegate userInfoViewDidTouchOneStepRecoryButton:self] ;
    }
}

-(IBAction)btn_Deposit:(id)sender
{
    ifRespondsSelector(self.delegate, @selector(userInfoViewDidTouchOneStepDepositeButton:)){
        [self.delegate userInfoViewDidTouchOneStepDepositeButton:self] ;
    }
}

@end
