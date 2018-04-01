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
#import "RH_DepositeTransferChannelModel.h"
#import "RH_DepositeTransferOrderNumCell.h"
#import "RH_DepositeTransferPayAdressCell.h"
#import "RH_API.h"
#import "coreLib.h"
#import "RH_DepositOriginseachSaleModel.h"
#import "RH_DepositeTransferButtonCell.h"
@interface RH_DepositeTransferBankcardController ()<DepositeTransferReminderCellDelegate,RH_ServiceRequestDelegate,DepositeTransferButtonCellDelegate,DepositeSubmitCircleViewDelegate>
@property(nonatomic,strong,readonly)RH_DepositeSubmitCircleView *circleView;
@property(nonatomic,strong)UIView *shadeView;
@property(nonatomic,strong)NSArray *markArray;
@property(nonatomic,assign)NSInteger indexMark;
@property(nonatomic,strong)NSArray *transferwayArray;
@property(nonatomic,strong)RH_DepositeTransferListModel *listModel;
@property(nonatomic,strong)NSMutableArray *accountMuArray;
@property(nonatomic,strong)RH_DepositOriginseachSaleModel *saleModel;
@property(nonatomic,assign)NSInteger activityId;
@property(nonatomic,strong)RH_DepositeTransferOrderNumCell *transferOrderCell ;
@property(nonatomic,strong)RH_DepositeTransferPayAdressCell *adressCell;
@property(nonatomic,strong)RH_DepositeTransferPayWayCell *paywayCell;
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
    RH_DepositeTransferListModel *listModel = ConvertToClassPointer(RH_DepositeTransferListModel, self.accountMuArray[1]);
    self.listModel = listModel;
    if ([self.accountMuArray[2] isEqualToString:@"company"]) {
        _markArray =@[@0,@7,@6,@1,@2,@5,@3,@4];
    }
    else if ([self.accountMuArray[2] isEqualToString:@"wechat"]){
        _markArray =@[@7,@0,@1,@2,@3,@6,@4,@5];

    }
    else if ([self.accountMuArray[2] isEqualToString:@"alipay"])
    {
        _markArray =@[@7,@0,@1,@2,@3,@4,@5,@6];;
    }
    else if ([self.accountMuArray[2] isEqualToString:@"qq"])
    {
        _markArray =@[@7,@0,@1,@2,@3,@6,@4,@5];
    }
    else if ([self.accountMuArray[2] isEqualToString:@"jd"])
    {
        _markArray =@[@7,@0,@1,@2,@3,@6,@4,@5];
    }
    else if ([self.accountMuArray[2] isEqualToString:@"bd"])
    {
        _markArray =@[@7,@0,@1,@2,@3,@6,@4,@5];
    }
    else if ([self.accountMuArray[2] isEqualToString:@"onecodepay"]){
        _markArray =@[@7,@0,@1,@2,@5,@6,@3,@4];
    }
    else if ([self.accountMuArray[2] isEqualToString:@"counter"]){
        _markArray =@[@0,@7,@6,@1,@2,@3,@4,@5];
    }
    else if ([self.accountMuArray[2] isEqualToString:@"other"])
    {
        _markArray = @[@7,@0,@1,@2,@3,@6,@4,@5];
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
    [self.contentTableView registerCellWithClass:[RH_DepositeTransferButtonCell class]];
}
#pragma mark --点击提交按钮弹框
-(RH_DepositeSubmitCircleView *)circleView
{
    if (!_circleView) {
        _circleView = [RH_DepositeSubmitCircleView createInstance];
        _circleView.frame = CGRectMake(0, 0, 250, 360);
        _circleView.center = self.view.center;
        _circleView.delegate = self;
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
    if ([self.accountMuArray[2] isEqualToString:@"company"] ) {
        return 5;
    }
    else if ([self.accountMuArray[2] isEqualToString:@"wechat"]||[self.transferwayArray[0]isEqualToString:@"counter"]){
        return 6;
    }
    else if ([self.accountMuArray[2] isEqualToString:@"alipay"])
    {
        return 7;
    }
    else if ([self.accountMuArray[2]isEqualToString:@"onecodepay"]){
        return 5;
    }
    return  6 ;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==[_markArray[0] integerValue]) {
        return 180.0f ;
    }
    else if (indexPath.item==[_markArray[1] integerValue]){
        return 190.f;
    }
    else if (indexPath.item==[_markArray[2] integerValue])
    {
        return 190.f;
    }
    else if (indexPath.item==[_markArray[3] integerValue])
    {
        return 44.f;
    }
    else if (indexPath.item==[_markArray[4] integerValue]){
        return 44.f;
    }
    else if (indexPath.item ==[_markArray[5] integerValue]){
        return 44.f;
    }
    else if (indexPath.item==[_markArray[6] integerValue]){
        return 80.f;
    }
    else if (indexPath.item==[_markArray[7]integerValue]){
        return 200.f;
    }
    
    return 0.f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.item==[_markArray[0] integerValue]) {
        RH_DepositeTransferBankInfoCell *bankInfoCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferBankInfoCell defaultReuseIdentifier]] ;
//        payforWayCell.delegate = self;
        [bankInfoCell updateCellWithInfo:nil context:self.listModel];
        return bankInfoCell ;
    }
    else if (indexPath.item==[_markArray[1]integerValue]){
        RH_DepositeTransferWXinInfoCell *wxInfoCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferWXinInfoCell defaultReuseIdentifier]] ;
        //        platformCell.delegate=self;
        [wxInfoCell updateCellWithInfo:nil context:self.listModel];
        return wxInfoCell ;
    }
    else if (indexPath.item == [_markArray[2]integerValue]){
        RH_DepositeTransferQRCodeCell *qrcodeCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferQRCodeCell defaultReuseIdentifier]] ;
        //        platformCell.delegate=self;
        //        [qrcodeCell updateCellWithInfo:nil context:self.accountModel];
        return qrcodeCell ;
        
    }
    else if (indexPath.item == [_markArray[3] integerValue]){
        RH_DepositeTransferPayWayCell *paywayCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferPayWayCell defaultReuseIdentifier]] ;
        self.paywayCell = paywayCell;
        [paywayCell updateCellWithInfo:nil context:self.accountMuArray[2]];
        return paywayCell ;
    }
    else if (indexPath.item == [_markArray[4] integerValue]){
        RH_DepositeTransferOrderNumCell *orderCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferOrderNumCell defaultReuseIdentifier]] ;
        self.transferOrderCell = orderCell;
       [orderCell updateCellWithInfo:nil context:self.accountMuArray[2]];
        return orderCell ;
    }
    else if (indexPath.item == [_markArray[5] integerValue]){
        RH_DepositeTransferPayAdressCell *paywayCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferPayAdressCell defaultReuseIdentifier]] ;
        self.adressCell = paywayCell;
       [paywayCell updateCellWithInfo:nil context:self.accountMuArray[2]];
        return paywayCell ;
    }
    else if (indexPath.item == [_markArray[6] integerValue]){
        RH_DepositeTransferButtonCell *btnCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferButtonCell defaultReuseIdentifier]];
        btnCell.delegate = self;
        return btnCell;
    }
    else if (indexPath.item == [_markArray[7] integerValue]){
        RH_DepositeTransferReminderCell *reminderCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeTransferReminderCell defaultReuseIdentifier]] ;
        reminderCell.delegate=self;
        //        [reminderCell updateCellWithInfo:nil context:self.accountModel];
        return reminderCell ;
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
#pragma mark --点击提交按钮
-(void)selectedDepositeTransferButton:(RH_DepositeTransferButtonCell *)cell
{
    [self submitDepositeInfo];
}
#pragma mark --选择弹框列表
-(void)depositeSubmitCircleViewChooseDiscount:(NSInteger)activityId
{
    self.activityId = activityId;
}
#pragma mark -- 点击弹框里面的提交按钮
-(void)depositeSubmitCircleViewTransferMoney:(RH_DepositeSubmitCircleView *)circleView
{
    if ([self.accountMuArray[2]isEqualToString:@"wechat"]||
        [self.accountMuArray[2]isEqualToString:@"qq"]||
        [self.accountMuArray[2]isEqualToString:@"jd"]||
        [self.accountMuArray[2]isEqualToString:@"bd"]||
        [self.accountMuArray[2]isEqualToString:@"bitcion"]||
        [self.accountMuArray[2]isEqualToString:@"unionpay"]) {
        [self.serviceRequest startV3ElectronicPayWithRechargeAmount:[self.accountMuArray[0]floatValue] rechargeType:self.listModel.mRechargeType payAccountId:self.listModel.mSearchId bankOrder:12345 payerName:@"12" payerBankcard:self.paywayCell.paywayString activityId:self.activityId];
        
    }
    else if ([self.accountMuArray[2]isEqualToString:@"alipay"])
    {
        [self.serviceRequest startV3AlipayElectronicPayWithRechargeAmount:[self.accountMuArray[0]floatValue] rechargeType:self.listModel.mRechargeType payAccountId:self.listModel.mSearchId bankOrder:12345 payerName:self.paywayCell.paywayString payerBankcard:self.transferOrderCell.transferOrderString activityId:self.activityId];
    }
    else if ([self.accountMuArray[2]isEqualToString:@"company"]){
        [self.serviceRequest startV3CompanyPayWithRechargeAmount:[self.accountMuArray[0]floatValue] rechargeType:self.listModel.mRechargeType payAccountId:self.listModel.mSearchId payerName:self.transferOrderCell.transferOrderString
         activityId:self.activityId];
    }
    else if ([self.accountMuArray[2]isEqualToString:@"counter"]){
        [self.serviceRequest startV3CounterPayWithRechargeAmount:[self.accountMuArray[0]floatValue] rechargeType:self.listModel.mRechargeType payAccountId:self.listModel.mSearchId payerName:self.transferOrderCell.transferOrderString rechargeAddress:self.adressCell.adressStr activityId:self.activityId];
    }
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
    [self.serviceRequest startV3DepositOriginSeachSaleRechargeAmount:[self.accountMuArray[0] floatValue] PayAccountDepositWay:self.listModel.mDepositWay PayAccountID:self.listModel.mSearchId];
    
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
