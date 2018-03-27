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
#import "RH_DepositePayAccountModel.h"
#import "RH_DepositeTransferOrderNumCell.h"
#import "RH_DepositeTransferPayAdressCell.h"
#import "RH_API.h"
#import "coreLib.h"
#import "RH_DepositOriginseachSaleModel.h"
@interface RH_DepositeTransferBankcardController ()<DepositeTransferReminderCellDelegate,RH_ServiceRequestDelegate>
@property(nonatomic,strong,readonly)RH_DepositeSubmitCircleView *circleView;
@property(nonatomic,strong)UIView *shadeView;
@property(nonatomic,strong)NSArray *markArray;
@property(nonatomic,assign)NSInteger indexMark;
@property(nonatomic,strong)NSArray *transferwayArray;
@property(nonatomic,strong)RH_DepositePayAccountModel *accountModel;
@property(nonatomic,strong)NSMutableArray *accountMuArray;
@property(nonatomic,strong)RH_DepositOriginseachSaleModel *saleModel;
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
    self.accountMuArray = [NSMutableArray array];
    self.accountMuArray = ConvertToClassPointer(NSMutableArray, context);
    self.transferwayArray = self.accountMuArray[0];
    RH_DepositePayAccountModel *accountModel = ConvertToClassPointer(RH_DepositePayAccountModel, self.transferwayArray[1]);
    self.accountModel = accountModel;
    if ([self.transferwayArray[0] isEqualToString:@"company"]) {
        _markArray =@[@0,@1,@2,@3,@4,@5];
    }
    else if ([self.transferwayArray[0] isEqualToString:@"wechat"]){
        _markArray =@[@5,@2,@3,@4,@1,@0];

    }
    else if ([self.transferwayArray[0] isEqualToString:@"alipay"])
    {
        _markArray =@[@6,@2,@3,@5,@1,@0,@4];
    }
    else if ([self.transferwayArray[0] isEqualToString:@"qqWallet"])
    {
        _markArray =@[@5,@2,@3,@4,@1,@0];
    }
    else if ([self.transferwayArray[0] isEqualToString:@"jdPay"])
    {
        _markArray =@[@5,@2,@3,@4,@1,@0];
    }
    else if ([self.transferwayArray[0] isEqualToString:@"baifuPay"])
    {
        _markArray =@[@5,@2,@3,@4,@1,@0];
    }
    else if ([self.transferwayArray[0] isEqualToString:@"oneCodePay"]){
        _markArray =@[@5,@2,@4,@3,@1,@0];
    }
    else if ([self.transferwayArray[0]isEqualToString:@"counter"]){
        _markArray =@[@0,@1,@2,@4,@6,@5,@3];
    }
    else if ([self.transferwayArray[0]isEqualToString:@"other"])
    {
        _markArray = @[@5,@2,@3,@4,@1,@0];
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
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferOrderNumCell class]];
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferPayAdressCell class]];
    
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
    if ([self.transferwayArray[0] isEqualToString:@"company"] ) {
        return 4;
    }
    else if ([self.transferwayArray[0] isEqualToString:@"wechat"]||[self.transferwayArray[0]isEqualToString:@"counter"]){
        return 5;
    }
    else if ([self.transferwayArray[0] isEqualToString:@"alipay"])
    {
        return 6;
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
//    else if (indexPath.item ==[_markArray[4] integerValue]){
//        return 200.f;
//    }
    else if (indexPath.item ==[_markArray[5] integerValue]){
        return 180.f;
    }
    else if (indexPath.item==[_markArray[6] integerValue]){
        return 44.f;
    }
    return 0.f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==[_markArray[0] integerValue]) {
        RH_DepositeTransferBankInfoCell *bankInfoCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferBankInfoCell defaultReuseIdentifier]] ;
//        payforWayCell.delegate = self;
        [bankInfoCell updateCellWithInfo:nil context:self.accountModel];
        return bankInfoCell ;
    }
    else if (indexPath.item == [_markArray[1] integerValue]){
        RH_DepositeTransferPayWayCell *paywayCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferPayWayCell defaultReuseIdentifier]] ;
        [paywayCell updateCellWithInfo:nil context:self.transferwayArray];
        return paywayCell ;
    }
    else if (indexPath.item == [_markArray[2] integerValue]){
        RH_DepositeTransferOrderNumCell *orderCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferOrderNumCell defaultReuseIdentifier]] ;
       [orderCell updateCellWithInfo:nil context:self.transferwayArray];
        return orderCell ;
    }
    else if (indexPath.item == [_markArray[3] integerValue]){
        RH_DepositeTransferReminderCell *reminderCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferReminderCell defaultReuseIdentifier]] ;
        reminderCell.delegate=self;
        [reminderCell updateCellWithInfo:nil context:self.accountModel];
        return reminderCell ;
    }
    else if (indexPath.item == [_markArray[4]integerValue]){
        RH_DepositeTransferQRCodeCell *qrcodeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferQRCodeCell defaultReuseIdentifier]] ;
        //        platformCell.delegate=self;
        [qrcodeCell updateCellWithInfo:nil context:self.accountModel];
        return qrcodeCell ;    }
    else if (indexPath.item==[_markArray[5]integerValue]){
        RH_DepositeTransferWXinInfoCell *wxInfoCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferWXinInfoCell defaultReuseIdentifier]] ;
//        platformCell.delegate=self;
        [wxInfoCell updateCellWithInfo:nil context:self.accountModel];
        return wxInfoCell ;
    }
    else if (indexPath.item == [_markArray[6] integerValue]){
        RH_DepositeTransferPayAdressCell *paywayCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferPayAdressCell defaultReuseIdentifier]] ;
       [paywayCell updateCellWithInfo:nil context:self.transferwayArray];
        return paywayCell ;
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
    [self setupPageLoadManager];
    
}
#pragma mark --点击遮罩层，关闭遮罩层和弹框
-(void)closeShadeView
{
    [_shadeView removeFromSuperview];
    [self.circleView removeFromSuperview];
}
#pragma mark 数据请求

#pragma mark - serviceRequest
-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (CLPageLoadManagerForTableAndCollectionView *)createPageLoadManager
{
    return [[CLPageLoadManagerForTableAndCollectionView alloc] initWithScrollView:self.contentTableView
                                                          pageLoadControllerClass:nil
                                                                         pageSize:[self defaultPageSize]
                                                                     startSection:0
                                                                         startRow:0
                                                                   segmentedCount:1] ;
}

-(BOOL)showNotingIndicaterView
{
    [self.loadingIndicateView showNothingWithImage:ImageWithName(@"empty_searchRec_image")
                                             title:nil
                                        detailText:@"您暂无相关数据记录"] ;
    return YES ;
    
}
#pragma mark-
-(void)netStatusChangedHandle
{
    if (NetworkAvailable()){
        [self startUpdateData] ;
    }
}
#pragma mark- 请求回调

-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
//
    [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:[self.accountMuArray[1] floatValue] PayAccountDepositWay:self.accountModel.mDepositWay PayAccountID:self.accountModel.mId];
    
}
-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleAllServices] ;
}

#pragma mark-
- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self startUpdateData] ;
}
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data {
    
    if (type == ServiceRequestTypeV3DepositOriginSeachSale) {
        RH_DepositOriginseachSaleModel *saleModel = ConvertToClassPointer(RH_DepositOriginseachSaleModel, data);
        self.saleModel = saleModel;
        [self loadDataSuccessWithDatas:saleModel?@[saleModel]:@[]
                            totalCount:saleModel?1:0] ;
        //遮罩层
        UIView *shadeView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        shadeView.backgroundColor = [UIColor lightGrayColor];
        shadeView.alpha = 0.7f;
        shadeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeShadeView)];
        [shadeView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:shadeView];
        _shadeView = shadeView;
        [self.circleView setupViewWithContext:self.saleModel];
        [[UIApplication sharedApplication].keyWindow addSubview:self.circleView];
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3DepositOriginSeachSale) {
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
}


@end
