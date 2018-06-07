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

#import "RH_ShareRecordCollectionPageCell.h"
#import "RH_ShareRecordTableViewCell.h"



@interface RH_ShareViewController ()<RH_ShareNaviBarViewDelegate,RH_ShareToFriendTableViewCellDelegate>
@property(nonatomic,  strong, readonly)RH_ShareNavBarView *shareNavView ;
@property(nonatomic,strong,readonly)UITableView *tableView ;
@property(nonatomic,strong) RH_SharePlayerRecommendModel *model;
@property (nonatomic,strong,readonly) RH_ShareAnnounceView *announceView ;


@property(nonatomic,strong)NSDictionary *dataDic ;

@end
@implementation RH_ShareViewController
@synthesize shareNavView = _shareNavView ;
@synthesize tableView = _tableView ;
//@synthesize model = _model;
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
    _dataDic = [NSMutableDictionary dictionary];
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
    [[NSNotificationCenter defaultCenter]addObserverForName:@"RH_ShareRecodStartDate_NT" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        RH_ShareRecordCollectionPageCell *cell = note.object[0];
        RH_ShareRecordTableViewCell *viewCell = note.object[1];
        NSDate *defaultDate = note.object[2];
        [self showCalendarView:@"设置开始日期"
                initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
                       MinDate:nil
                       MaxDate:[NSDate date]
                  comfirmBlock:^(NSDate *returnDate) {
                      viewCell.startDate = returnDate ;
                      cell.startDate = dateStringWithFormatter(returnDate, @"yyyy-MM-dd");
                  }] ;
    }];
    [[NSNotificationCenter defaultCenter]addObserverForName:@"RH_ShareRecodEndDate_NT" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        RH_ShareRecordCollectionPageCell *cell = note.object[0];
        RH_ShareRecordTableViewCell *viewCell = note.object[1];
        NSDate *defaultDate = note.object[2];
        [self showCalendarView:@"设置截止日期"
                initDateString:dateStringWithFormatter(defaultDate, @"yyyy-MM-dd")
                       MinDate:nil
                       MaxDate:[NSDate date]
                  comfirmBlock:^(NSDate *returnDate) {
                      viewCell.startDate = returnDate ;
                      cell.startDate = dateStringWithFormatter(returnDate, @"yyyy-MM-dd");
                  }] ;
    }];
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
        return 300.f/375*screenSize().width ;
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
        [cell updateCellWithInfo:nil context:self.model];
        return cell ;
    }
    return nil;
}
#pragma mark - 复制按钮点击
-(void)shareToFriendTableViewCellDidTouchCopyButton:(RH_ShareToFriendTableViewCell *)shareToFriendTableViewCell
{
    showAlertView(@"提示", @"复制成功");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
