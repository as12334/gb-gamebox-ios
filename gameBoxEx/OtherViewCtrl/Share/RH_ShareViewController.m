//
//  RH_ShareViewController.m
//  gameBoxEx
//
//  Created by Richard on 2018/2/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_ShareViewController.h"
#import "coreLib.h"
#import "RH_ShareNavBarView.h"
#import "RH_ShareCountTableViewCell.h"
#import "RH_NonTableViewCell.h"
#import "RH_ShareToFriendTableViewCell.h"
#import "RH_FirstBigViewCell.h"
#import "RH_SharePlayerRecommendModel.h"
#import "RH_ShareAnnounceView.h"
#import "RH_ShareRecordTableViewCell.h"
#import "RH_ShareRecordModel.h"


@interface RH_ShareViewController ()<RH_ShareNaviBarViewDelegate,RH_ShareToFriendTableViewCellDelegate,FirstBigViewCellDelegate>
@property(nonatomic,  strong, readonly)RH_ShareNavBarView *shareNavView ;
@property(nonatomic,strong,readonly)UITableView *tableView ;
@property(nonatomic,strong) RH_SharePlayerRecommendModel *model;
@property (nonatomic,strong,readonly) RH_ShareAnnounceView *announceView ;
@property(nonatomic,strong)RH_ShareRecordModel *shareRecordModel;
@end
@implementation RH_ShareViewController
@synthesize shareNavView = _shareNavView ;
@synthesize tableView = _tableView ;
@synthesize announceView = _announceView ;





-(RH_SharePlayerRecommendModel *)model
{
    if (!_model) {
        _model = [[RH_SharePlayerRecommendModel alloc] init ];
    }
    return _model ;
}

-(BOOL)hasNavigationBar
{
    return NO ;
}

- (BOOL)isSubViewController {
    return YES;
}

-(BOOL)hasTopView
{
    return YES ;
}

-(BOOL)topViewIncludeStatusBar
{
    return YES ;
}

-(CGFloat)topViewHeight
{
    return StatusBarHeight+NavigationBarHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI] ;
    self.view.backgroundColor = colorWithRGB(255, 255, 255);
    [self setNeedUpdateView] ;
    [self.serviceRequest startV3LoadSharePlayerRecommend] ;
//    NSDate *startDate = [[NSDate alloc]init];
//    [startDate dateWithMoveDay:-30];
//    NSDate *endDate = [[NSDate alloc]init];
//    [self.serviceRequest startV3SharePlayerRecordStartTime:dateStringWithFormatter([startDate dateWithMoveDay:-30], @"yyyy-MM-dd") endTime:dateStringWithFormatter(endDate, @"yyyy-MM-dd") pageNumber:0 pageSize:20];
    
    [self.serviceRequest startV3SharePlayerRecordStartTime:[self getCurrentTimes] endTime:[self getCurrentTimes] pageNumber:0 pageSize:20];
    
    
}


-(void)configUI
{
    UIImageView* bgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"share_bg"]];
    bgview.frame = self.view.bounds ;
    bgview.userInteractionEnabled  = YES ;
    [self.view addSubview:bgview];

    [bgview addSubview:self.tableView];
    [self.tableView registerClass:[RH_ShareCountTableViewCell class] forCellReuseIdentifier:[RH_ShareCountTableViewCell defaultReuseIdentifier]];
    [self.tableView registerClass:[RH_NonTableViewCell class] forCellReuseIdentifier:[RH_NonTableViewCell defaultReuseIdentifier]];
    [self.tableView registerClass:[RH_ShareToFriendTableViewCell class] forCellReuseIdentifier:[RH_ShareToFriendTableViewCell defaultReuseIdentifier]];
    [self.tableView registerClass:[RH_FirstBigViewCell class] forCellReuseIdentifier:[RH_FirstBigViewCell defaultReuseIdentifier]];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.shareNavView];
    self.shareNavView.whc_LeftSpace(0).whc_TopSpace(20).whc_BottomSpace(0).whc_RightSpace(0) ;
}

#pragma 获取当天日期
-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",formatter);
    
    return currentTimeString;
    
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize().width, screenSize().height) style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0) ;
        _tableView.delegate = self ;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        _tableView.backgroundColor = [UIColor clearColor] ;
    }
    return _tableView;
}

#pragma mark -
-(RH_ShareNavBarView *)shareNavView
{
    if (!_shareNavView) {
        _shareNavView = [RH_ShareNavBarView createInstance] ;
        _shareNavView.delegate = self ;
    }
    return _shareNavView;
}

-(RH_ShareAnnounceView *)announceView
{
    if (!_announceView) {
        _announceView = [RH_ShareAnnounceView createInstance] ;
        self.announceView.alpha = 0.f;
    }
    return _announceView;
}

#pragma mark- observer Touch gesture
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return (self.announceView.superview?YES:NO) ;
}
#pragma mark -- 返回
-(void)shareNaviBarViewDidTouchBackButton:(RH_ShareNavBarView *)shareNaviBarView
{
    [self backBarButtonItemHandle] ;
}
#pragma mark -公告按钮
-(void)shareNaviBarViewDidTouchSettingButton:(RH_ShareNavBarView *)shareNaviBarView
{
    if (self.announceView.superview == nil) {
        _announceView = [RH_ShareAnnounceView createInstance] ;
        self.announceView.alpha = 0;
        [self.view.window addSubview:self.announceView];
        self.announceView.whc_TopSpace(0).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.announceView.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.announceView showContentWith:@[_model.mActivityRules]];
                
            }
        }];
    }
}



#pragma mark - service request
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3SharePlayerRecommend){
        [self setNeedUpdateView] ;
        _model = data;
        [self.tableView reloadData];
    }
    else if (type==ServiceRequestTypeV3SharePlayerRecord){
        self.shareRecordModel = ConvertToClassPointer(RH_ShareRecordModel, data);
        [self.tableView reloadData];
        // 1.创建通知打开settingView的通知
        NSNotification *notificationClose =[NSNotification notificationWithName:@"loadShareRecordTableView" object:nil userInfo:nil];
        // 2.通过 通知中心 发送 通知
        [[NSNotificationCenter defaultCenter] postNotification:notificationClose];
    }
}
//移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadShareRecordTableView" object:nil];
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3SharePlayerRecommend){
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
}

#pragma mark-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80.f;
    }else if (indexPath.row == 1){
        return 10.f/375*screenSize().width ;
    }else if (indexPath.row == 2)
    {
        return 117.f/375*screenSize().width;
    }else if (indexPath.row == 3){
        return 10.f ;
    }else if (indexPath.row == 4){
//        return 300.f/375*screenSize().width ;
        return screenSize().height/7*4 ;
    }
    else{
        return 80.f ;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        RH_ShareCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_ShareCountTableViewCell defaultReuseIdentifier]] ;
        [cell updateCellWithInfo:nil context:_model];
        return cell;
    }else if (indexPath.row == 1){
        RH_NonTableViewCell *nonCell = [tableView dequeueReusableCellWithIdentifier:[RH_NonTableViewCell defaultReuseIdentifier]] ;
        return nonCell ;
    }else if(indexPath.row == 2)
    {
        RH_ShareToFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_ShareToFriendTableViewCell defaultReuseIdentifier]] ;
        cell.delegate = self ;
        [cell updateCellWithInfo:nil context:_model];
        return cell ;
    }else if (indexPath.row == 3){
        RH_NonTableViewCell *nonCell = [tableView dequeueReusableCellWithIdentifier:[RH_NonTableViewCell defaultReuseIdentifier]] ;
        return nonCell ;
    }else if (indexPath.row == 4){
        RH_FirstBigViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_FirstBigViewCell defaultReuseIdentifier]] ;
        cell.backgroundColor = [UIColor clearColor];
        if (self.model!=nil&&self.shareRecordModel!=nil) {
            [cell updateCellWithInfo:nil context:@[self.model,self.shareRecordModel]];
        }
        cell.delegate = self;
        return cell ;
    }
    return nil;
}
#pragma mark - 复制按钮点击
-(void)shareToFriendTableViewCellDidTouchCopyButton:(RH_ShareToFriendTableViewCell *)shareToFriendTableViewCell
{
    showAlertView(@"提示", @"复制成功");
}
#pragma mark ==============searchbtn delegate================
-(void)firstBigViewCellSearchSharelist:(NSDate *)startDate endDate:(NSDate *)endDate
{
    
    
    NSString *startDateStr =dateStringWithFormatter(startDate, @"yyyy-MM-dd");
    NSString *endDateStr = dateStringWithFormatter(endDate, @"yyyy-MM-dd");
    if ([startDateStr compare:endDateStr]==NSOrderedDescending) {
        showMessage(self.view, @"选择的日期不对，请重新选择", nil);
        return;
    }
    startDateStr = [startDateStr stringByAppendingString:@" 00:00:01"];
    endDateStr = [endDateStr stringByAppendingString:@" 23:59:59"];
    [self.serviceRequest startV3SharePlayerRecordStartTime:startDateStr endTime:endDateStr pageNumber:0 pageSize:50];
}


@end
