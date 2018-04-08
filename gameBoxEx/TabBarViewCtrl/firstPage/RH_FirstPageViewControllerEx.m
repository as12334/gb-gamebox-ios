 //
//  RH_FirstPageViewControllerEx.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_FirstPageViewControllerEx.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RH_APPDelegate.h"
#import "RH_CustomViewController.h"
#import "RH_BannerViewCell.h"
#import "RH_DaynamicLabelCell.h"
#import "RH_HomeCategoryCell.h"
#import "RH_HomeChildCategoryCell.h"
#import "RH_HomeCategoryItemsCell.h"
#import "RH_HomePageModel.h"
#import "RH_ActivithyView.h"
#import "RH_API.h"
#import "RH_BasicAlertView.h"
#import "RH_UserInfoManager.h"
#import "RH_CustomViewController.h"
#import "RH_GamesViewController.h"
#import "RH_GameListViewController.h"
#import "RH_ActivityModel.h"
#import "RH_OpenActivityModel.h"
#import "RH_NormalActivithyView.h"
#import "RH_GameListViewController.h"
#import "RH_ActivityStatusModel.h"
#import "RH_UserInfoManager.h"
#import "RH_AdvertisementView.h"

@interface RH_FirstPageViewControllerEx ()<RH_ShowBannerDetailDelegate,HomeCategoryCellDelegate,HomeChildCategoryCellDelegate,
        ActivithyViewDelegate,
        HomeCategoryItemsCellDelegate,RH_NormalActivithyViewDelegate,AdvertisementViewDelegate>
//@property (nonatomic,strong,readonly) UILabel *labDomain ;
@property (nonatomic,strong,readonly) RH_DaynamicLabelCell *dynamicLabCell ;
@property (nonatomic,strong,readonly) RH_HomeCategoryCell *homeCategoryCell ;
@property (nonatomic,strong,readonly) RH_HomeChildCategoryCell *homeChildCatetoryCell  ;
@property (nonatomic,strong,readonly) RH_HomeCategoryItemsCell *homeCategoryItemsCell ;
@property (nonatomic, strong) RH_BasicAlertView *rhAlertView ;
@property (nonatomic,strong)  RH_ActivityModel *activityModel;
@property (nonatomic,strong) RH_AdvertisementView *advertisentView ;
//-
@property (nonatomic,strong,readonly) RH_LotteryCategoryModel *selectedCategoryModel ;
@property (nonatomic,strong,readonly) NSArray *currentCategoryItemsList;
@property (nonatomic,strong,readonly) RH_ActivithyView *activityView ;
@property (nonatomic,strong)RH_OpenActivityModel *openActivityModel;
@property (nonatomic,strong)RH_ActivityStatusModel *statusModel;
@property (nonatomic,strong,readonly) RH_NormalActivithyView *normalActivityView;
@property (nonatomic,strong)UIView *shadeView;
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation RH_FirstPageViewControllerEx
//@synthesize  labDomain = _labDomain                         ;
@synthesize dynamicLabCell = _dynamicLabCell                ;
@synthesize homeCategoryCell = _homeCategoryCell            ;
@synthesize homeChildCatetoryCell = _homeChildCatetoryCell  ;
@synthesize homeCategoryItemsCell = _homeCategoryItemsCell  ;
@synthesize activityView = _activityView                    ;
@synthesize normalActivityView= _normalActivityView         ;
@synthesize advertisentView = _advertisentView ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBarItem.leftBarButtonItem = self.logoButtonItem      ;
    [self.serviceRequest startGetCustomService] ;
    [self.topView addSubview:self.mainNavigationView] ;
    
    [self setNeedUpdateView] ;
    [self setupUI] ;
    self.needObserverTapGesture = YES ;
    //增加login status changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:NT_LoginStatusChangedNotification object:nil] ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"didRegistratedSuccessful" object:nil];
    _hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    _hud.removeFromSuperViewOnHide = YES;
    
    [self.serviceRequest startV3SiteTimezone] ;
    //自动登录
    [self autoLogin] ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

-(BOOL)hasNavigationBar
{
    return NO ;
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
    return self.mainNavigationView.frameHeigh ;
}

#pragma mark - autoLogin
- (void) autoLogin{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *account ;
    NSString *password ;
    //判断是否记住密码进行自动登录
    if([[defaults stringForKey:@"loginIsRemberPassword"] boolValue])
    {
        account = [defaults objectForKey:@"account"];
        password = [defaults objectForKey:@"password"];
    }else
    {
        account = [defaults objectForKey:@"account"];
        password = nil ;
    }
    if(account.length==0 || password.length ==0){
        return;
    }
    [self.serviceRequest startAutoLoginWithUserName:account Password:password] ;
    return ;
};

#pragma mark-
-(void)handleNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        [self setNeedUpdateView] ;
    }
    if ([nt.name isEqualToString:@"didRegistratedSuccessful"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *account ;
        NSString *password ;
        account = [defaults objectForKey:@"account"];
        password = [defaults objectForKey:@"password"];
        [self.serviceRequest startAutoLoginWithUserName:account Password:password] ;
    }
}

//#pragma mark-
//-(UILabel*)labDomain
//{
//    if (!_labDomain){
//        _labDomain = [[UILabel alloc] init] ;
//        if ([self.appDelegate.domain containsString:@"//"]){
//            NSArray *tmpArray = [self.appDelegate.domain componentsSeparatedByString:@"//"] ;
//            _labDomain.text = [NSString stringWithFormat:@"易记域名:%@",tmpArray.count>1?tmpArray[1]:tmpArray[0]] ;
//        }else{
//            _labDomain.text = [NSString stringWithFormat:@"易记域名:%@",self.appDelegate.domain] ;
//        }
//        _labDomain.font = [UIFont systemFontOfSize:12.0f] ;
//        _labDomain.textColor = [UIColor whiteColor] ;
//        _labDomain.translatesAutoresizingMaskIntoConstraints = NO ;
//    }
//
//    return _labDomain ;
//}

#pragma mark - rhAlertView
-(RH_BasicAlertView *)rhAlertView
{
    if (!_rhAlertView){
        _rhAlertView = [RH_BasicAlertView createInstance] ;
        self.rhAlertView.alpha = 0.f;
    }
    return _rhAlertView ;
}

-(RH_AdvertisementView *)advertisentView
{
    if (!_advertisentView) {
        _advertisentView = [RH_AdvertisementView createInstance] ;
        _advertisentView.delegate = self ;
    }
    return _advertisentView ;
}

#pragma mark - AdvertisementViewDelegate
-(void)advertisementViewDidTouchSureBtn:(RH_AdvertisementView *)advertisementView DataModel:(RH_PhoneDialogModel *)phoneModel
{
    [advertisementView hideAdvertisementView] ;
    self.appDelegate.customUrl = phoneModel.link ;
    [self showViewController:[RH_CustomViewController viewController] sender:self] ;
    return ;
}

#pragma mark- observer Touch gesture
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return (self.userInfoView.superview?YES:NO)||(self.rhAlertView.superview?YES:NO) ;
}

-(void)tapGestureRecognizerHandle:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if (self.userInfoView.superview){
        [self userInfoButtonItemHandle] ;
    }
}

#pragma mark-
-(void)setupUI
{
//    [self.topView addSubview:self.labDomain] ;
//    setCenterConstraint(self.labDomain, self.topView) ;
//    self.topView.backgroundColor = RH_NavigationBar_BackgroundColor ;
//    self.topView.borderMask = CLBorderMarkTop ;
//    self.topView.borderColor = colorWithRGB(204, 204, 204) ;
    self.contentTableView = [self createTableViewWithStyle:UITableViewStyleGrouped updateControl:NO loadControl:NO] ;
    self.contentTableView.delegate = self   ;
    self.contentTableView.dataSource = self ;
    self.contentTableView.sectionFooterHeight = 0.0f ;
    self.contentTableView.sectionHeaderHeight = 0.0f ;
    
    [self.contentTableView registerCellWithClass:[RH_BannerViewCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_DaynamicLabelCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_HomeCategoryCell class]] ;
    [self.contentTableView registerCellWithClass:[RH_HomeChildCategoryCell class]] ;
    
    [self.contentView addSubview:self.contentTableView] ;
    self.contentTableView.backgroundColor = [UIColor whiteColor] ;
    if ([THEMEV3 isEqualToString:@"black"]||[THEMEV3 isEqualToString:@"green"]) {
        self.contentTableView.backgroundColor = RH_NavigationBar_BackgroundColor_Black ;
    }
    
    [self setupPageLoadManager] ;
    
    UIView *foot_View = [UIView new];
    foot_View.frame = CGRectMake(0, 0, screenSize().width, 20);
    UILabel *label = [UILabel new];
    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(0, 0, screenSize().width, 1);
    
    
    [foot_View addSubview:label];
    [foot_View addSubview:lineView];
    lineView.whc_TopSpace(10).whc_CenterX(0).whc_Height(1.5).whc_LeftSpace(10).whc_RightSpace(10);
    label.whc_TopSpace(15).whc_CenterX(0).whc_Height(30).whc_LeftSpace(30).whc_RightSpace(30);
    label.font = [UIFont systemFontOfSize:9];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = colorWithRGB(51, 51, 51);
    if ([THEMEV3 isEqualToString:@"black"])
    {
        label.textColor = colorWithRGB(85, 85, 85);
        lineView.backgroundColor = colorWithRGB(37, 37, 37);
    }else{
        label.textColor = colorWithRGB(153, 153, 153);
        lineView.backgroundColor = colorWithRGB(239, 239, 239);
    }
    label.text = @"COPYRIGHT © 2004-2018";
    self.contentTableView.tableFooterView = foot_View;
}

-(RH_LoadingIndicateView*)contentLoadingIndicateView
{
    return self.loadingIndicateTableViewCell.loadingIndicateView ;
}


- (CLPageLoadManagerForTableAndCollectionView *)createPageLoadManager
{
    return [[CLPageLoadManagerForTableAndCollectionView alloc] initWithScrollView:self.contentTableView
                                                          pageLoadControllerClass:[CLSectionArrayPageLoadController class]
                                                                         pageSize:[self defaultPageSize]
                                                                     startSection:0
                                                                         startRow:0
                                                                   segmentedCount:1] ;
}

-(void)updateView
{
    if (self.appDelegate.isLogin){
        self.navigationBarItem.rightBarButtonItems = @[self.userInfoButtonItem] ;
        [self startUpdateData] ;
        
    }else{
        self.navigationBarItem.rightBarButtonItems = @[self.signButtonItem,self.loginButtonItem] ;
        if (self.userInfoView.superview){
            [self userInfoButtonItemHandle] ;
        }
    }
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    if (self.appDelegate.isLogin){
        [self.serviceRequest startV3GetUserAssertInfo] ;
    }
}
#pragma mark-
-(RH_DaynamicLabelCell *)dynamicLabCell
{
    if (!_dynamicLabCell){
        _dynamicLabCell = [RH_DaynamicLabelCell createInstance] ;
    }
    return _dynamicLabCell ;
}

#pragma mark- homeCategoryCell-
-(RH_HomeCategoryCell *)homeCategoryCell
{
    if (!_homeCategoryCell){
        _homeCategoryCell = [RH_HomeCategoryCell createInstance] ;
        _homeCategoryCell.delegate = self ;
    }
    
    return _homeCategoryCell ;
}

-(void)homeCategoryCellDidChangedSelectedIndex:(RH_HomeCategoryCell*)homeCategoryCell
{
    [self.contentTableView reloadData] ;
}

#pragma mark -homeChildCatetoryCell
-(RH_HomeChildCategoryCell *)homeChildCatetoryCell
{
    if (!_homeChildCatetoryCell){
        _homeChildCatetoryCell = [RH_HomeChildCategoryCell createInstance] ;

        _homeChildCatetoryCell.delegate = self ;
    }
    return _homeChildCatetoryCell ;
}

-(void)homeChildCategoryCellDidChangedSelectedIndex:(RH_HomeChildCategoryCell*)homeChildCategoryCell
{
    [self.contentTableView reloadData] ;
}


#pragma mark- homeCategoryItemsCell
-(RH_HomeCategoryItemsCell *)homeCategoryItemsCell
{
    if (!_homeCategoryItemsCell){
        _homeCategoryItemsCell = [RH_HomeCategoryItemsCell createInstance] ;
        _homeCategoryItemsCell.delegate = self ;
    }
    
    return _homeCategoryItemsCell ;
}

-(void)homeCategoryItemsCellDidTouchItemCell:(RH_HomeCategoryItemsCell*)homeCategoryItem DataModel:(id)cellItemModel
{
    if (HasLogin)
    {
        if ([cellItemModel isKindOfClass:[RH_LotteryAPIInfoModel class]]){
            RH_LotteryAPIInfoModel *lotteryAPIInfoModel = ConvertToClassPointer(RH_LotteryAPIInfoModel, cellItemModel) ;
            if (lotteryAPIInfoModel.mApiTypeID==2){ ////进入 电子游戏 列表 。。。
                [self showViewController:[RH_GameListViewController viewControllerWithContext:lotteryAPIInfoModel]
                                  sender:self] ;
                return ;
            }else if (lotteryAPIInfoModel.mAutoPay){//免转
                [self showViewController:[RH_GamesViewController viewControllerWithContext:lotteryAPIInfoModel] sender:self] ;
                return ;
            }else{ //非免转 ---跳到额度转换里 自已转钱入游戏 。
                if (lotteryAPIInfoModel.mGameLink.length){
                    if ([lotteryAPIInfoModel.mGameLink containsString:@"mobile-api"]){//通过gamelink请求url
                        [self showViewController:[RH_GamesViewController viewControllerWithContext:lotteryAPIInfoModel] sender:self] ;
                        return ;
                    }else{
                        self.appDelegate.customUrl = lotteryAPIInfoModel.showGameLink ;
                        [self showViewController:[RH_CustomViewController viewController] sender:self] ;
                        return ;
                    }
                }else{
                    showAlertView(@"提示信息",@"数据异常,请联系客服!") ;
                    return ;
                }
            }
        }else if ([cellItemModel isKindOfClass:[RH_LotteryInfoModel class]]){
            RH_LotteryInfoModel *lotteryInfoModel = ConvertToClassPointer(RH_LotteryInfoModel, cellItemModel) ;
            if (lotteryInfoModel.mAutoPay){ //免转
                [self showViewController:[RH_CustomViewController viewControllerWithContext:lotteryInfoModel] sender:self] ;
                return ;
            }else { //非免转 ---跳到额度转换里 自已转钱入游戏 。
                if (lotteryInfoModel.mGameLink.length){
                    if ([lotteryInfoModel.mGameLink containsString:@"mobile-api"]){//通过gamelink请求url
                        [self showViewController:[RH_GamesViewController viewControllerWithContext:lotteryInfoModel] sender:self] ;
                        return ;
                    }else{
                        self.appDelegate.customUrl = lotteryInfoModel.showGameLink ;
                        [self showViewController:[RH_CustomViewController viewController] sender:self] ;
                        return ;
                    }
                }else{
                    showAlertView(@"提示信息",@"数据异常,请联系客服!") ;
                    return ;
                }
            }
        }
    }else{
        if ([cellItemModel isKindOfClass:[RH_LotteryAPIInfoModel class]]){
            RH_LotteryAPIInfoModel *lotteryAPIInfoModel = ConvertToClassPointer(RH_LotteryAPIInfoModel, cellItemModel) ;
            if (lotteryAPIInfoModel.mApiTypeID==2){ //进入 电子游戏 列表 。。。
                [self showViewController:[RH_GameListViewController viewControllerWithContext:lotteryAPIInfoModel]
                                  sender:self] ;
                return ;
            }
        }
        //进入登录界面
        [self loginButtonItemHandle] ;
    }
}

#pragma mark- selectedCategoryModel
-(RH_LotteryCategoryModel *)selectedCategoryModel
{
    RH_HomePageModel *homePageModel = ConvertToClassPointer(RH_HomePageModel, [self.pageLoadManager dataAtIndex:0]) ;
    if (homePageModel){
        return [homePageModel.mLotteryCategoryList objectAtIndex:self.homeCategoryCell.selectedIndex] ;
    }
    return nil ;
}

-(NSArray *)currentCategoryItemsList
{
    if (self.selectedCategoryModel.isExistSubCategory){
        NSInteger index = self.homeChildCatetoryCell.selectedIndex ;
        RH_LotteryAPIInfoModel *lotteryApiModel = self.selectedCategoryModel.mSiteApis[index] ;
        return lotteryApiModel.mGameItems ;
    }else{
        if (self.selectedCategoryModel.mSiteApis.count==1){//中间只有一层分类信息
            return self.selectedCategoryModel.mSiteApis[0].mGameItems ;
        }
        return self.selectedCategoryModel.mSiteApis ;
    }
}

#pragma mark-activityView
-(RH_ActivithyView *)activityView
{
    if (!_activityView){
        _activityView = [RH_ActivithyView createInstance] ;
        _activityView.frame = CGRectMake(self.view.frameWidth - activithyViewWidth -5,
                                         self.view.frameHeigh - activithyViewHeigh ,
                                         activithyViewWidth,
                                         activithyViewHeigh
        ) ;
        _activityView.delegate = self ;
    }
    
    return _activityView ;
}
#pragma mark 拆红包大图
-(RH_NormalActivithyView *)normalActivityView
{
    if (!_normalActivityView) {
        _normalActivityView = [RH_NormalActivithyView createInstance];
        _normalActivityView.frame =CGRectMake(0, 0, 300, 350);
        _normalActivityView.center =self.view.center;
        _normalActivityView.delegate = self;
    }
    return _normalActivityView;
}
#pragma mark 第一次拆红包代理
-(void)normalActivityViewFirstOpenActivityClick:(RH_NormalActivithyView *)view
{
     RH_HomePageModel *homePageModel = ConvertToClassPointer(RH_HomePageModel, [self.pageLoadManager dataAtIndex:0]) ;
    [self.serviceRequest startV3OpenActivity:homePageModel.mActivityInfo.mActivityID andGBtoken:self.statusModel.mToken];
    [_hud show:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:_hud];
}
#pragma mark 拆红包代理
-(void)normalActivithyViewOpenActivityClick:(RH_NormalActivithyView *)view
{
    RH_HomePageModel *homePageModel = ConvertToClassPointer(RH_HomePageModel, [self.pageLoadManager dataAtIndex:0]) ;
    [self.serviceRequest startV3OpenActivity:homePageModel.mActivityInfo.mActivityID andGBtoken:self.openActivityModel.mToken];
    [_hud show:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:_hud];
}
-(void)normalActivityViewCloseActivityClick:(RH_NormalActivithyView *)view
{
    [self.shadeView removeFromSuperview];
    [self.normalActivityView removeFromSuperview];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.normalActivityView closeClick:self.normalActivityView];
}
#pragma mark 点击小图标关闭按钮
-(void)activityViewDidTouchCloseActivityView:(RH_ActivithyView *)activityView
{
    [self activityViewHide] ;
}
-(void)activithyViewDidTouchActivityView:(RH_ActivithyView*)activityView
{
    
    if (self.appDelegate.isLogin&&NetworkAvailable()){
        RH_HomePageModel *homePageModel = ConvertToClassPointer(RH_HomePageModel, [self.pageLoadManager dataAtIndex:0]) ;
        [self.serviceRequest startV3ActivityStaus:homePageModel.mActivityInfo.mActivityID];
        [_hud show:YES];
        [[UIApplication sharedApplication].keyWindow addSubview:_hud];
    }
    else if(!self.appDelegate.isLogin){
        //进入登录界面
        [self loginButtonItemHandle] ;
    }
    else if (NetNotReachability()){
        showAlertView(@"无网络", @"无网络打不开红包") ;
    }
   
}
//点击红包小图标加载红包动画
-(void)touchActivityViewAndOpentheActivity
{
    //在window上加一个遮罩层
    UIView *bigView = [[UIView alloc]initWithFrame:MainScreenBounds];
    bigView.backgroundColor = [UIColor grayColor];
    bigView.alpha = 0.8;
    [self.view.window addSubview:bigView];
    _shadeView = bigView;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frameWidth - activithyViewWidth -5,self.view.frameHeigh - activithyViewHeigh ,activithyViewWidth,activithyViewHeigh)];
    imageView.image = self.activityView.imgView.image;
    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
    //红包动画
    [UIView animateWithDuration:1.f animations:^{
        imageView.center = self.view.center;
        imageView.alpha = 0;
        CGRect frame = imageView.frame;
        frame.size.width +=100;
        frame.size.height +=100;
        imageView.frame=frame;
        CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
        animation.duration  = 1;
        animation.speed = 2;
        animation.autoreverses = NO;
        animation.fillMode =kCAFillModeForwards;
        animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
        [imageView.layer addAnimation:animation forKey:nil];
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow addSubview:self.normalActivityView];
    }];
}
-(void)activithyViewDidTouchCancel:(RH_ActivithyView*)activityView
{
    [self activityViewHide] ;
}

-(void)activityViewShowWith:(RH_ActivityModel*)activityModel
{
    if (self.activityView.superview) return ;
    self.activityView.alpha = 0.0 ;
    [self.view addSubview:self.activityView] ;
    self.activityView.whc_RightSpace(5).whc_BottomSpace(20).whc_Width(100).whc_Height(100);
    
    [UIView animateWithDuration:1.0f animations:^{
        self.activityView.activityModel = activityModel ;
    } completion:^(BOOL finished) {
        self.activityView.alpha = 1.0f;
    }] ;
}

-(void)activityViewHide{
    if (self.activityView.superview){
        [UIView animateWithDuration:1.0f animations:^{
//            self.activityView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.activityView setHidden:YES] ;
            [self.activityView.deleteButton setHidden:YES];
//            [self.activityView whc_ResetConstraints] ;
        }] ;
    }
}

#pragma mark- netStatusChangedHandle
-(void)netStatusChangedHandle
{
    if (NetworkAvailable() && [self.pageLoadManager currentDataCount]==0){
        [self startUpdateData] ;
    }
}

#pragma mark- 请求回调
-(void)loadDataHandleWithPage:(NSUInteger)page andPageSize:(NSUInteger)pageSize
{
    [self.activityView setHidden:NO] ;
    [self.activityView.deleteButton setHidden:NO];
    [self.serviceRequest startV3HomeInfo] ;
    if (self.appDelegate.isLogin) {
        [self.serviceRequest startV3GetUserAssertInfo] ;
        [self.serviceRequest startV3RereshUserSessin] ;
    }
}

-(void)cancelLoadDataHandle
{
    [self.serviceRequest cancleServiceWithType:ServiceRequestTypeV3HomeInfo] ;
}

#pragma mark-
- (void)loadingIndicateViewDidTap:(CLLoadingIndicateView *)loadingIndicateView
{
    [self startUpdateData] ;
}


#pragma mark-
- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest   serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3HomeInfo){
        RH_HomePageModel *homePageModel = ConvertToClassPointer(RH_HomePageModel, data) ;
        [self loadDataSuccessWithDatas:homePageModel?@[homePageModel]:nil
                            totalCount:homePageModel?1:1] ;
        if (homePageModel.mActivityInfo){
            [self activityViewShowWith:homePageModel.mActivityInfo] ;
            self.normalActivityView.activityModel = homePageModel.mActivityInfo;
        }else{
            [self activityViewHide] ;
        }
        NSArray *phoneDataArr = homePageModel.phoneDialogModel ;
        if (phoneDataArr.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view.window addSubview:self.advertisentView];
                self.advertisentView.whc_LeftSpace(0).whc_RightSpace(0).whc_TopSpace(0).whc_BottomSpace(0) ;
                [self.advertisentView advertisementViewUpDataWithModel:homePageModel.phoneDialogModel[0]] ;
            }) ;
        }
    }else if (type == ServiceRequestTypeDemoLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            if ([data boolValue]){
                showSuccessMessage(self.view, @"试玩登录成功", nil) ;
                [self.appDelegate updateLoginStatus:true] ;
                
            }else{
                showAlertView(@"试玩登录失败", @"提示信息");
                [self.appDelegate updateLoginStatus:false] ;
            }
        }] ;
    }else if (type == ServiceRequestTypeUserAutoLogin || type == ServiceRequestTypeUserLogin){
        if (self.progressIndicatorView.superview){
            [self hideProgressIndicatorViewWithAnimated:YES completedBlock:nil] ;
            NSDictionary *dict = ConvertToClassPointer(NSDictionary, data) ;
            if ([dict boolValueForKey:@"success" defaultValue:FALSE]){
                [self.appDelegate updateLoginStatus:true] ;
            }else{
                [self.appDelegate updateLoginStatus:false] ;
            }
            
        }else{
            NSDictionary *dict = ConvertToClassPointer(NSDictionary, data) ;
            if ([dict boolValueForKey:@"success" defaultValue:FALSE]){
                [self.appDelegate updateLoginStatus:true] ;
            }else{
                [self.appDelegate updateLoginStatus:false] ;
            }
        }
        
    }else if (type == ServiceRequestTypeV3ActivityStatus){
        RH_ActivityStatusModel *statusModel = ConvertToClassPointer(RH_ActivityStatusModel, data);
        self.normalActivityView.statusModel = statusModel;
        self.statusModel = statusModel;
        [self touchActivityViewAndOpentheActivity];
        [self.hud hide:YES];
    }
    else if (type == ServiceRequestTypeV3OpenActivity){
        self.openActivityModel = ConvertToClassPointer(RH_OpenActivityModel, data);
        self.normalActivityView.openModel = self.openActivityModel;
        [self.hud hide: YES];
        
    }else if (type == ServiceRequestTypeV3OneStepRecory){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showSuccessMessage(self.view, @"提示信息", [data objectForKey:@"message"]) ;
            [self.serviceRequest startV3GetUserAssertInfo] ;
        }] ;
    }else if (type == ServiceRequestTypeV3RefreshSession){
        
    }else if (type == ServiceRequestTypeV3OneStepRefresh){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showSuccessMessage(self.view, @"提示信息", @"资金刷新成功") ;
            [self.serviceRequest startV3GetUserAssertInfo] ;
        }] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3HomeInfo){
        [self loadDataFailWithError:error] ;
    }else if (type == ServiceRequestTypeDemoLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showAlertView(@"试玩登录失败", @"提示信息");
        }] ;
    }else if (type == ServiceRequestTypeUserAutoLogin || type == ServiceRequestTypeUserLogin){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showAlertView(@"自动登录失败", @"提示信息");
        }] ;
    }else if (type == ServiceRequestTypeV3OneStepRecory){
        
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(nil, error, @"提示信息") ;
        }] ;
    }
    else if (type==ServiceRequestTypeV3ActivityStatus){
        showErrorMessage(nil, error, @"红包获取失败") ;
        [self.shadeView removeFromSuperview];
        [self.hud hide: YES];
    }
    else if (type==ServiceRequestTypeV3OpenActivity){
        showErrorMessage(nil, error, @"红包获取失败") ;
        [self.shadeView removeFromSuperview];
        [self.hud hide: YES];
    }else if (type == ServiceRequestTypeV3RefreshSession){
    }else if (type == ServiceRequestTypeV3OneStepRefresh){
        [self hideProgressIndicatorViewWithAnimated:YES completedBlock:^{
            showErrorMessage(nil, error, @"资金刷新失败") ;
        }] ;
    }
}

#pragma mark-tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MAX(1, self.pageLoadManager.currentDataCount?5:0) ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.pageLoadManager.currentDataCount){
        RH_HomePageModel *homePageModel = ConvertToClassPointer(RH_HomePageModel, [self.pageLoadManager dataAtIndex:0]) ;
        switch (section) {
            case 0: //bannel
//                return homePageModel.mBannerList.count?1:0 ;
                return 1 ;
                break;
            
            case 1: //announcement
                return homePageModel.mAnnouncementList.count?1:0 ;
                break;
            
            case 2: //category
                return homePageModel.mLotteryCategoryList.count?1:0 ;
                break;
           
            case 3: //child category
                {
                    return self.selectedCategoryModel.isExistSubCategory?1:0 ;
                }
                break;
            
            case 4: // categoryitem
            {
                return 1 ;
            }
                break;
            default:
                break;
        }
        
    }else{
        return  1 ;
    }
    
    return  0 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        if (indexPath.section==0){
            return [RH_BannerViewCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
        }else if (indexPath.section==1){
            return [RH_DaynamicLabelCell heightForCellWithInfo:nil tableView:tableView context:nil];
        }else if (indexPath.section==2){
                return [RH_HomeCategoryCell heightForCellWithInfo:nil tableView:tableView context:nil];
        }else if (indexPath.section==3){
            return [RH_HomeChildCategoryCell heightForCellWithInfo:nil tableView:tableView context:nil] ;
        }else if (indexPath.section==4){
            return [RH_HomeCategoryItemsCell heightForCellWithInfo:nil tableView:tableView context:self.currentCategoryItemsList];
        }else{
            return 0.0f ;
        }
    }else{
        return MainScreenH  - TabBarHeight - [self topViewHeight];
    }
    return 0.0f ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageLoadManager.currentDataCount){
        RH_HomePageModel *homePageModel = ConvertToClassPointer(RH_HomePageModel, [self.pageLoadManager dataAtIndex:0]) ;
        if (indexPath.section==0){
            RH_BannerViewCell *bannerViewCell = [self.contentTableView dequeueReusableCellWithIdentifier:[RH_BannerViewCell defaultReuseIdentifier]] ;
            bannerViewCell.delegate = self ;
            [bannerViewCell updateCellWithInfo:nil context:homePageModel.mBannerList];
            return bannerViewCell ;
        }else if (indexPath.section==1){
            [self.dynamicLabCell updateCellWithInfo:nil context:homePageModel.showAnnouncementContent];
            return self.dynamicLabCell ;
        }else if (indexPath.section==2){
            [self.homeCategoryCell updateCellWithInfo:nil context:homePageModel] ;
            return self.homeCategoryCell  ;
        }else if (indexPath.section==3){
            [self.homeChildCatetoryCell updateCellWithInfo:nil context:self.selectedCategoryModel.mSiteApis] ;
            return self.homeChildCatetoryCell  ;
        }else if (indexPath.section==4){
            if (self.currentCategoryItemsList.count){
                [self.homeCategoryItemsCell updateCellWithInfo:nil context:self.currentCategoryItemsList] ;
                return self.homeCategoryItemsCell  ;
            }else{
                [self.loadingIndicateTableViewCell.loadingIndicateView showSearchEmptyStatus] ;
                return self.loadingIndicateTableViewCell ;
            }
        }
    }else{
        return self.loadingIndicateTableViewCell ;
    }
    
    return nil ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1){
        RH_HomePageModel *homePageModel = ConvertToClassPointer(RH_HomePageModel, [self.pageLoadManager dataAtIndex:0]) ;
        if (self.rhAlertView.superview == nil) {
            self.rhAlertView = [RH_BasicAlertView createInstance];
            self.rhAlertView.alpha = 0;
            [self.view.window addSubview:self.rhAlertView];
            self.rhAlertView.whc_TopSpace(0).whc_LeftSpace(0).whc_BottomSpace(0).whc_RightSpace(0);

            [UIView animateWithDuration:0.3 animations:^{
                self.rhAlertView.alpha = 1;
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.rhAlertView showContentWith:homePageModel.mAnnouncementList];
                    
                }
            }];
        }
    }
}

#pragma mark- Banner Cells Delegate
- (void)object:(id)object wantToShowBannerDetail:(id<RH_BannerModelProtocol>)bannerModel
{
    if (bannerModel.contentURL.length){
        self.appDelegate.customUrl = bannerModel.contentURL ;
        [self showViewController:[RH_CustomViewController viewController] sender:self] ;
    }
}

@end
