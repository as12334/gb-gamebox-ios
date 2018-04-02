//
//  RH_DepositBitcionViewController.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/31.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositBitcionViewController.h"
#import "RH_DepositeBitcionCell.h"
#import "coreLib.h"
#import "RH_DepositeTransferChannelModel.h"
#import "RH_DepositOriginseachSaleModel.h"
#import "RH_DepositeSubmitCircleView.h"

@interface RH_DepositBitcionViewController ()<DepositeBitcionCellDelegate,DepositeSubmitCircleViewDelegate,PGDatePickerDelegate>
@property(nonatomic,strong)NSArray *listModelArray;
@property(nonatomic,strong)RH_DepositeBitcionCell *bitcionCell;
@property(nonatomic,strong,readonly)RH_DepositeSubmitCircleView *circleView;
@property(nonatomic,strong)UIView *shadeView;
@property(nonatomic,assign)NSInteger activityId;
@property(nonatomic,strong)RH_DepositeTransferListModel *listModel;

@end

@implementation RH_DepositBitcionViewController
@synthesize circleView = _circleView;
-(BOOL)isSubViewController
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"比特币支付";
    [self setupUI];
}
-(void)setupViewContext:(id)context{
    RH_DepositeTransferChannelModel *channelModel = ConvertToClassPointer(RH_DepositeTransferChannelModel, context);
    self.listModelArray = ConvertToClassPointer(NSArray, channelModel.mArrayListModel);
    RH_DepositeTransferListModel *listModel = ConvertToClassPointer(RH_DepositeTransferListModel, channelModel.mArrayListModel[0]);
    self.listModel = listModel;
    
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
    [self.contentTableView registerCellWithClass:[RH_DepositeBitcionCell class]] ;
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
#pragma mark -- 优惠列表
-(void)depositeSubmitCircleViewChooseDiscount:(NSInteger)activityId
{
    self.activityId = activityId;
}
#pragma mark 点击textfield改变fame的代理
-(void)depositeBitcionCellUpframe:(RH_DepositeBitcionCell *)bitcoinCell
{
    [self.contentTableView setContentOffset:CGPointMake(0,200) animated:YES];
}
#pragma mark -- 点击弹框里面的提交按钮
-(void)depositeSubmitCircleViewTransferMoney:(RH_DepositeSubmitCircleView *)circleView
{
    [self.serviceRequest startV3BitcoinPayWithRechargeType:self.listModel.mRechargeType payAccountId:self.listModel.mSearchId activityId:self.activityId returnTime:@"2018-02-28 12:00:00" payerBankcard:self.bitcionCell.bitcoinAdressStr bitAmount:[self.bitcionCell.bitcoinNumStr floatValue] bankOrderTxID:self.bitcionCell.txidStr];
}

-(void)depositeBitcionCellDidTouchTimeSelectView:(RH_DepositeBitcionCell *)bitcoinCell DefaultDate:(NSDate *)defaultDate
{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType2;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
    [self presentViewController:datePickManager animated:false completion:nil];
    self.bitcionCell = bitcoinCell ;
}

#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:date];
    self.bitcionCell.bitConDate = date ;
    NSLog(@"date: %@", dateString);
}

-(void)depositeBitcionCellDidTouchSaveToPhoneWithUrl:(NSString *)imageUrl
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrl]]];
    UIImage *myImage = [UIImage imageWithData:data];
    [self saveImageToPhotos:myImage];
}

#pragma mark-tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return  1 ;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 750.f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RH_DepositeBitcionCell *bitecionCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_DepositeBitcionCell defaultReuseIdentifier]] ;
    self.bitcionCell = bitecionCell;
    [bitecionCell updateCellWithInfo:nil context:self.listModel];
    bitecionCell.delegate = self;
    return bitecionCell ;
}

#pragma mark --点击提交按钮
-(void)depositeBitcionCellSubmit:(RH_DepositeBitcionCell *)bitcoinCell
{
     [self.contentTableView setContentOffset:CGPointMake(0,0) animated:YES];
    if (self.bitcionCell.bitcoinAdressStr==nil||self.bitcionCell.bitcoinAdressStr.length<26||self.bitcionCell.bitcoinAdressStr.length>34) {
        showMessage(self.view, @"请输入26位~34位比特币地址", nil);
    }
    else{
        if (self.bitcionCell.txidStr==nil||self.bitcionCell.txidStr.length>64) {
          showMessage(self.view, @"请输入小于64位交易产生的txid", nil);
        }
        else{
            if (self.bitcionCell.bitcoinNumStr==nil||[self.bitcionCell.bitcoinNumStr floatValue]>100000000) {
                showMessage(self.view, @"请输入整数小于8位，小数小于8位的比特币数量", nil);
            }
            else
            {
                if (self.bitcionCell.bitcoinChangeTimeStr==nil) {
                    showMessage(self.view, @"请输入交易时间", nil);
                }
                else
                {
                      [self.serviceRequest startV3DepositOriginSeachSaleBittionRechargeAmount:[self.bitcionCell.bitcoinNumStr floatValue] PayAccountDepositWay:self.listModel.mDepositWay bittionTxid:[self.bitcionCell.txidStr integerValue] PayAccountID:self.listModel.mSearchId];
                }
            }
        }
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
    
    if (type == ServiceRequestTypeV3DepositOriginBittionSeachSale) {
        RH_DepositOriginseachSaleModel *saleModel = ConvertToClassPointer(RH_DepositOriginseachSaleModel, data);
        //        self.saleModel = saleModel;
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
        [self.circleView setupViewWithContext:saleModel];
        [[UIApplication sharedApplication].keyWindow addSubview:self.circleView];
    }
    else if (type==ServiceRequestTypeV3BitcoinPay){
        showMessage(self.circleView, @"存款成功", nil);
    }
}
#pragma mark --点击遮罩层，关闭遮罩层和弹框
-(void)closeShadeView
{
    
    [_shadeView removeFromSuperview];
    [self.circleView removeFromSuperview];
}
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3DepositOriginBittionSeachSale) {
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
    else if (type==ServiceRequestTypeV3BitcoinPay){
        showErrorMessage(self.circleView, error, @"存款失败") ;
    }
}

@end
