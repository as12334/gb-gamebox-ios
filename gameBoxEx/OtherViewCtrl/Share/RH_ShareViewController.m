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


@interface RH_ShareViewController ()<RH_ShareNaviBarViewDelegate>
@property(nonatomic,  strong, readonly)RH_ShareNavBarView *shareNavView ;
@property (nonatomic, strong, readonly) CLTableViewManagement *tableViewManagement;
@end
@implementation RH_ShareViewController
@synthesize shareNavView = _shareNavView ;
@synthesize tableViewManagement = _tableViewManagement ;

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
    [self setupInfo];
    self.view.backgroundColor = colorWithRGB(255, 255, 255);
    [self setNeedUpdateView] ;
    [self.serviceRequest startV3LoadSharePlayerRecommend] ;
}

#pragma mark-
- (void)setupInfo {
    [self.topView addSubview:self.shareNavView] ;
    self.shareNavView.whc_LeftSpace(0).whc_TopSpace(20).whc_BottomSpace(0).whc_RightSpace(0) ;
    
    self.contentTableView = [self createTableViewWithStyle:UITableViewStylePlain updateControl:NO loadControl:NO];
    UIEdgeInsets edgeInset = self.contentTableView.contentInset ;
    edgeInset.top -= heighStatusBar +heighNavigationBar ;
    self.contentTableView.contentInset = edgeInset ;
    self.contentTableView.scrollIndicatorInsets = edgeInset ;
    UIImageView *bgImage = [[UIImageView alloc] init];
    self.contentTableView.backgroundView = bgImage ;
    bgImage.image = ImageWithName(@"share_bg");
//    bgImage.whc_LeftSpace(0).whc_RightSpace(0).whc_TopSpace(0).whc_BottomSpace(0) ;
   
    [self.contentView addSubview:self.contentTableView];
    [self.tableViewManagement reloadData];
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
#pragma mark -- 返回
-(void)shareNaviBarViewDidTouchBackButton:(RH_ShareNavBarView *)shareNaviBarView
{
    [self backBarButtonItemHandle] ;
}
#pragma mark -设置界面
-(void)shareNaviBarViewDidTouchSettingButton:(RH_ShareNavBarView *)shareNaviBarView
{
    
}
#pragma mark - service request
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3SharePlayerRecommend){
        //        RH_UserGroupInfoModel *infoModel = ConvertToClassPointer(RH_UserGroupInfoModel, data);
        //       self.mineInfoModel = ConvertToClassPointer(RH_MineInfoModel, infoModel.mUserSetting);
        //        [self.tableViewManagement reloadData];
        [self setNeedUpdateView] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error {
    if (type == ServiceRequestTypeV3SharePlayerRecommend){
        [self.contentLoadingIndicateView showDefaultLoadingErrorStatus:error] ;
    }
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
