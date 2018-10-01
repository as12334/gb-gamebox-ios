//
//  RH_ExampleViewController.m
//  gameBoxEx
//
//  Created by barca on 2018/9/29.
//  Copyright © 2018 luis. All rights reserved.
//
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#import "RH_ExampleViewController.h"
#import "UIView+frame.h"
#import "RH_DiscountActivityModel.h"
#import "RH_NewPromoTableViewCell.h"
#import "GameWebViewController.h"
#import "CheckTimeManager.h"
#import "RH_DiscountActivityModel.h"

@interface RH_ExampleViewController ()<UITableViewDelegate,UITableViewDataSource,PromoTableViewCellDelegaet>
{
    NSString *_strKey;
}
@end
@implementation RH_ExampleViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationBar.hidden = YES;
}
- (void)initWithIndex:(NSInteger)index ActivityTypeModel:(RH_DiscountActivityTypeModel *)activityTypeModel
{
    _strKey = activityTypeModel.mActivityKey;
    [self startUpdateData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentTableView = [self createTableViewWithStyle:(UITableViewStylePlain) updateControl:YES loadControl:NO];
    self.contentTableView.frame = CGRectMake(0,-40, ScreenWidth, ScreenHeight);
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    [self.contentTableView registerCellWithClass:[RH_NewPromoTableViewCell class]];
    [self.contentView addSubview:self.contentTableView];
    self.contentTableView.backgroundColor = [UIColor colorWithHexStr:@"#DEDEDE"];
    [self setupPageLoadManager];
    _strKey = @"all";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return MAX(1, self.pageLoadManager.currentDataCount);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        return 115;
    }else{
        return tableView.boundHeigh  - tableView.contentInset.bottom;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount > 0 ) {
        RH_NewPromoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RH_NewPromoTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"RH_NewPromoTableViewCell" owner:self options:nil]lastObject];
        }
        cell.promoDelegate = self;
        cell.cellIndexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell passRH_DiscountActivityModel:[self.pageLoadManager dataAtIndexPath:indexPath]];
         return cell;
    }else
    {
       return self.loadingIndicateTableViewCell ;
    }
}

-(void)cellToJump:(NSIndexPath *)cellIndexPath
{
    RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
    
    if (appDelegate.demainName == nil && [CheckTimeManager shared].lotteryLineCheckFail == NO) {
        //线路正在检测 则提示 正在获取可用线路 请稍后
        showErrorMessage(self.view, nil, @"正在获取可用线路 请稍后");
        return ;
    }
    RH_DiscountActivityModel *discountActivityModel = [self.pageLoadManager dataAtIndexPath:cellIndexPath];
    if ([CheckTimeManager shared].lotteryLineCheckFail) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GB_Retry_H5_Host" object:@{@"targetController":@"promoView",@"data":@[discountActivityModel]}];
        return ;
    }
    GameWebViewController *gameViewController = [[GameWebViewController alloc] initWithNibName:nil bundle:nil];
    gameViewController.hideMenuView = YES;
    NSString *checkType = [[self.appDelegate.checkType componentsSeparatedByString:@"+"] firstObject];
    gameViewController.url = [NSString stringWithFormat:@"%@://%@%@",checkType,self.appDelegate.demainName,discountActivityModel.mUrl];
    [self.navigationController pushViewController:gameViewController animated:YES];
}

#pragma mark-
- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type==ServiceRequestTypeV3ActivityDetailList)
    {
        NSArray *arrTmp = ConvertToClassPointer(NSArray, data);
        [self loadDataSuccessWithDatas:arrTmp
                            totalCount:arrTmp.count
                        completedBlock:nil];
        [self.contentTableView reloadData];

    }
}
- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type==ServiceRequestTypeV3ActivityDetailList )
    {
         [self loadDataFailWithError:error] ;
    }
}
#pragma mark-
-(void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self startUpdateData] ;
}
- (void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    //已存在数据情况 ，更新优惠标签 。
    if ([_strKey isEqualToString:@"all"]) {
        [self.serviceRequest startV3LoadDiscountActivityTypeListWithKey:@""] ;
    }else
    {
        [self.serviceRequest startV3LoadDiscountActivityTypeListWithKey:_strKey] ;
    }
}
-(void)cancelLoadDataHandle
{
}
//进行页面刷新
-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}

@end
