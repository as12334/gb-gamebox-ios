//
//  RH_DepositeTransferBankcardController.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferBankcardController.h"
#import "RH_DepositeSubmitCircleView.h"
#import "RH_DepositeTransferBankInfoCell.h"
#import "RH_DepositeTransferPayWayCell.h"
#import "RH_DepositeTransferReminderCell.h"
#import "RH_DepositeTransferQRCodeCell.h"
#import "RH_DepositeTransferWXinInfoCell.h"
@interface RH_DepositeTransferBankcardController ()<DepositeTransferReminderCellDelegate>
@property(nonatomic,strong,readonly)RH_DepositeSubmitCircleView *circleView;
@property(nonatomic,strong)UIView *shadeView;
@property(nonatomic,strong)NSArray *markArray;
@property(nonatomic,assign)NSInteger indexMark;
@end

@implementation RH_DepositeTransferBankcardController
@synthesize circleView = _circleView;
-(BOOL)isSubViewController
{
    return YES;
}
-(BOOL)hasBottomView
{
    return YES;
}
-(CGFloat)bottomViewHeight
{
    return 40.f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"银行卡转账";
    [self setupUI];
}
#pragma mark --获取点击的具体的item
-(void)setupViewContext:(id)context
{
    NSArray *array = ConvertToClassPointer(NSArray, context);
    if ([array[0] isEqualToString:@"company"]) {
        _markArray =@[@0,@1,@2,@3,@4,@5];
    }
    else if ([array[0] isEqualToString:@"wechat"]){
        _markArray =@[@5,@2,@3,@4,@1,@0];

    }
    else if ([array[0] isEqualToString:@"alipay"])
    {
        _markArray =@[@5,@2,@3,@4,@1,@0];
    }
    else{
       _markArray =@[@0,@1,@2,@3,@4,@5];
    }
}
#pragma mark --视图
-(void)setupUI{
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    self.contentTableView.separatorStyle = UITableViewRowActionStyleNormal;
    [self.contentView addSubview:self.contentTableView] ;
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferBankInfoCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferPayWayCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferReminderCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferQRCodeCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferWXinInfoCell class]];
    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(0, 0, self.contentView.frameWidth, 40);
    submitBtn.backgroundColor = [UIColor blueColor];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitDepositeInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:submitBtn];
}
#pragma mark --点击提交按钮弹框
-(RH_DepositeSubmitCircleView *)circleView
{
    if (!_circleView) {
        _circleView = [RH_DepositeSubmitCircleView createInstance];
        _circleView.frame = CGRectMake(0, 0, 250, 360);
        _circleView.center = self.view.center;
    }
    return _circleView;
}

#pragma mark-tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.indexMark ==0) {
        return 4;
    }
    else if (self.indexMark==2){
        return 5;
    }
    return  4 ;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==[_markArray[0] integerValue]) {
        return 180.0f ;
    }
    else if (indexPath.item==[_markArray[1] integerValue]){
        return 40.f;
    }
    else if (indexPath.item==[_markArray[2] integerValue])
    {
        return 40.f;
    }
    else if (indexPath.item==[_markArray[3] integerValue])
    {
        return 200.f;
    }
    else if (indexPath.item==[_markArray[4] integerValue]){
        return 190.f;
    }
//    else if (indexPath.item==[_markArray[3] integerValue]){
//        return 44.f;
//    }
//    else if (indexPath.item ==[_markArray[4] integerValue]){
//        return 200.f;
//    }
    else if (indexPath.item ==[_markArray[5] integerValue]){
        return 180.f;
    }
    return 0.f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==[_markArray[0] integerValue]) {
        RH_DepositeTransferBankInfoCell *bankInfoCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferBankInfoCell defaultReuseIdentifier]] ;
//        payforWayCell.delegate = self;
        return bankInfoCell ;
    }
    else if (indexPath.item == [_markArray[1] integerValue]){
        RH_DepositeTransferPayWayCell *paywayCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferPayWayCell defaultReuseIdentifier]] ;
        return paywayCell ;
    }
    else if (indexPath.item == [_markArray[2] integerValue]){
        RH_DepositeTransferPayWayCell *paywayCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferPayWayCell defaultReuseIdentifier]] ;
        paywayCell.leftTitleLabel.text = @"存款人";
        paywayCell.rightTitleLabel.text = @"转入账号对应的姓名";
        return paywayCell ;
    }
    else if (indexPath.item == [_markArray[3] integerValue]){
        RH_DepositeTransferReminderCell *reminderCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferReminderCell defaultReuseIdentifier]] ;
        reminderCell.delegate=self;
        return reminderCell ;
    }
    else if (indexPath.item == [_markArray[4]integerValue]){
        RH_DepositeTransferQRCodeCell *qrcodeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferQRCodeCell defaultReuseIdentifier]] ;
        //        platformCell.delegate=self;
        return qrcodeCell ;    }
    else if (indexPath.item==[_markArray[5]integerValue]){
        RH_DepositeTransferWXinInfoCell *wxInfoCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferWXinInfoCell defaultReuseIdentifier]] ;
//        platformCell.delegate=self;
        return wxInfoCell ;
    }
    return nil;
}
#pragma mark --RH_DepositeTransferReminderCell的代理，点击进入客服界面
-(void)touchTransferReminderTextViewPushCustomViewController:(RH_DepositeTransferReminderCell *)cell
{
    [self.tabBarController setSelectedIndex:3];
}
#pragma mark --点击提交按钮
-(void)submitDepositeInfo
{
    //遮罩层
    UIView *shadeView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    shadeView.backgroundColor = [UIColor lightGrayColor];
    shadeView.alpha = 0.7f;
    shadeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeShadeView)];
    [shadeView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:shadeView];
    _shadeView = shadeView;
    [[UIApplication sharedApplication].keyWindow addSubview:self.circleView];
}
#pragma mark --点击遮罩层，关闭遮罩层和弹框
-(void)closeShadeView
{
    [_shadeView removeFromSuperview];
    [self.circleView removeFromSuperview];
}


@end
