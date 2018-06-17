//
//  SplashViewController.m
//  gameBoxEx
//
//  Created by luis on 2017/10/7.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "SplashViewController.h"
#import "coreLib.h"
#import "RH_ServiceRequest.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"
#import "MacroDef.h"
#import "RH_UpdatedVersionModel.h"
#import "RH_DomainTableCell.h"
#import "RH_UserInfoManager.h"
#import "RH_ConcurrentServicesReqManager.h"

#define RHNT_DomainCheckSuccessful          @"DomainCheckSuccessful"
#define RHNT_DomainCheckFail                @"DomainCheckFail "

#define aiScreenWidth [UIScreen mainScreen].bounds.size.width
#define aiScreenHeight [UIScreen mainScreen].bounds.size.height
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATION_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define TAB_BAR_HEIGHT self.tabBarController.tabBar.frame.size.height

#define  kUpdateAPPDatePrompt                           @"kUpdateAPPDatePrompt"
#define  OneDayTotalInterval                             (24*60*60)

typedef NS_ENUM(NSInteger, DoMainStatus) {
    doMainStatus_None  = 0,
    doMainStatus_Checking ,
    doMainStatus_Successful ,
    doMainStatus_Failure ,
};

@interface _DoMainCheckStatusModel:NSObject
@property(nonatomic,strong,readonly) NSString *doMain        ;
@property(nonatomic,assign,readonly) DoMainStatus status        ;
@property(nonatomic,strong,readonly)UIButton *padonBtn;
-(instancetype)initWithDomain:(NSString*)domain Status:(DoMainStatus)status ;
-(NSString*)showStatus ;
@end

@implementation _DoMainCheckStatusModel
@synthesize padonBtn = _padonBtn;
-(instancetype)initWithDomain:(NSString*)domain Status:(DoMainStatus)status
{
    self = [super init] ;
    if (self){
        _doMain = domain ;
        _status = status ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:)
                                                     name:RHNT_DomainCheckSuccessful
                                                   object:nil] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:)
                                                     name:RHNT_DomainCheckFail
                                                   object:nil] ;
    }
    return self ;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

-(void)handleNotification:(NSNotification*)nt
{
    NSString *doMain = ConvertToClassPointer(NSString, nt.object) ;
    if ([doMain isEqualToString:self.doMain]){
        if ([nt.name isEqualToString:RHNT_DomainCheckSuccessful]){
            _status = doMainStatus_Successful ;
            return ;
        }else if ([nt.name isEqualToString:RHNT_DomainCheckFail]){
            _status = doMainStatus_Failure ;
            return ;
        }
    }
}
-(NSString*)showStatus
{
    switch (_status) {
        case doMainStatus_None:
            return @"等待检测中..." ;
            break;
        
        case doMainStatus_Checking:
            return @"检测中..." ;
            break;
            
        case doMainStatus_Successful:
            return @"检测成功..." ;
            break;
            
        case doMainStatus_Failure:
            return @"检测失败..." ;
            break;
            
        default:
            break;
    }
    
    return @"等待检测中..."  ;
}
@end


@interface SplashViewController ()<RH_ServiceRequestDelegate,RH_ConcurrentServicesReqManagerDelegate,RH_ServiceRequestDelegate>
@property(nonatomic,strong) UIWindow * window;
@property (weak, nonatomic) IBOutlet UIImageView *splashLogo;
@property (weak, nonatomic) IBOutlet UILabel *bottomText;
@property (weak, nonatomic) IBOutlet UILabel *bottomText2;
@property (nonatomic,strong) IBOutlet UILabel *labIPAddr ;
@property (nonatomic,strong) IBOutlet UILabel *labMark ;
@property (nonatomic,strong,readonly) NSMutableArray *checkDomainServices ;
@property (weak, nonatomic) IBOutlet UIImageView *startImge;
@property (weak, nonatomic) IBOutlet UITableView *domainTableView   ;
@property (nonatomic,strong) NSString *checkType;
//check到的域名
@property (nonatomic,strong)NSString *checkDominStr;
//获取 域名 list 并发请求管理器
//@property(nonatomic,strong,readonly) RH_ConcurrentServicesReqManager * concurrentServicesManager;
@property(nonatomic,readonly,strong)RH_ServiceRequest *serviceRequest;
@end

@implementation SplashViewController
{
    NSArray *_urlArray ;
    NSString *_talk ;
    int i;
}
@synthesize checkDomainServices = _checkDomainServices ;

//@synthesize concurrentServicesManager = _concurrentServicesManager ;
@synthesize serviceRequest = _serviceRequest;

-(RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest) {
        _serviceRequest = [[RH_ServiceRequest alloc]init];
        _serviceRequest.delegate = self;
    }
    return _serviceRequest;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.checkType = @"https+8989";
    i = 0;
    _talk = @"/__check" ;
    self.hiddenNavigationBar = YES ;
    self.hiddenStatusBar = YES ;
    self.hiddenTabBar = YES ;
    if (IS_DEV_SERVER_ENV || IS_TEST_SERVER_ENV)
    {
#ifdef TEST_DOMAIN
        _urlArray = @[TEST_DOMAIN] ;
        [self.appDelegate updateApiDomain:ConvertToClassPointer(NSString, [RH_API_MAIN_URL objectAtIndex:0])] ;
#endif
    }
    
    self.needObserveNetStatusChanged = YES ;
    //检测网络状态和加载UI -----步骤一
    [self netStatusChangedHandle] ;
    self.labMark.text = dateStringWithFormatter([NSDate date], @"HHmmss") ;
    [self initView] ;
}

#pragma mark-  检测网络，如果是WiFi或4G就可以检测线路 ---步骤二
-(void)netStatusChangedHandle
{
    NSString *network = @"网络不可用";
    NSString *wifiing = @"正在使用Wifi";
    //    NSString *wifi = @"Wifi已开启";
    NSString *flow = @"你现在使用的流量";
    NSString *unknown = @"你现在使用的未知网络";
    //    if ([@"185" isEqualToString:SID]) {
    //        network = @"ネット使用不可";
    //        wifiing = @"WiFi使用中";
    //        wifi = @"WiFiオープン";
    //        flow = @"パケット使用中";
    //        unknown = @"不明のネット使用中";
    //    }
    switch (CurrentNetStatus()) {
        case NotReachable:
        {
            [self addToastWithString:network inView:self.view];
        }
            break;
        case ReachableViaWiFi:
        {
            self.labIPAddr.text = getIPAddress(TRUE) ;
            [self addToastWithString:wifiing inView:self.view];
            if (_urlArray.count<1){
                [self startReqSiteInfo];
            }else{
                [self checkAllUrl] ;
            }
        }
            break ;
        case ReachableViaWWAN:
        {
            self.labIPAddr.text = getIPAddress(TRUE) ;
            [self addToastWithString:flow inView:self.view];
            if (_urlArray.count<1){
                [self startReqSiteInfo];
            }else{
                [self checkAllUrl] ;
            }
        }
            break ;
        default:
        {
            [self addToastWithString:unknown inView:self.view];
            if (_urlArray.count<1){
                [self startReqSiteInfo];
            }else{
                [self checkAllUrl] ;
            }
        }
            break;
    }
}
- (void)initView{
    //设置启动页logo
    NSString *logoName = [NSString stringWithFormat:@"app_logo_%@",SID] ;
    [self.splashLogo setImage:ImageWithName(logoName)];
    /**
     * 119 特殊处理
     */
    if ([SID isEqualToString:@"119"]) {
        self.splashLogo.hidden = YES;
        [self.startImge setImage:ImageWithName(@"startImage_119")];
    }
    else if ([SID isEqualToString:@"270"]){
        self.splashLogo.hidden = YES;
        [self.startImge setImage:ImageWithName(@"270startpage_1242x2209.jpg")];
    }
    else if ([SID isEqualToString:@"206"]){
        self.splashLogo.hidden = YES;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [self.bottomText setText:[NSString stringWithFormat:@"Copyrihgt © %@ Reserved.",app_Name]];
    [self.bottomText2 setText:[NSString stringWithFormat:@"v%@",app_Version]];
    
    [self.domainTableView registerCellWithClass:[RH_DomainTableCell class]] ;
    self.domainTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.domainTableView.hidden = YES ;
    
    //注册打开是否check成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notCheckDominSuccess:) name:@"youAreNotCheckSuccess" object:nil];
}

-(void)startReqSiteInfo
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil detailText:@"正在检查线路,请稍候"] ;
//    [self.concurrentServicesManager cancleAllServices] ;
     RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
    for (int i=0; i<RH_API_MAIN_URL.count; i++) {
        NSString *strTmp = ConvertToClassPointer(NSString, [RH_API_MAIN_URL objectAtIndex:i]) ;
        [self.serviceRequest startReqDomainListWithDomain:strTmp.trim] ;
        [appDelegate updateApiDomain:strTmp];
    }
}
#pragma mark ==============重复请求================
-(void)repetitionStartReqSiteInfo{
    _talk = @"/__check" ;
    if (IS_DEV_SERVER_ENV || IS_TEST_SERVER_ENV)
    {
#ifdef TEST_DOMAIN
        _urlArray = @[TEST_DOMAIN] ;
        [self.appDelegate updateApiDomain:ConvertToClassPointer(NSString, [RH_API_MAIN_URL objectAtIndex:0])] ;
#endif
    }
    
    self.needObserveNetStatusChanged = YES ;
    [self netStatusChangedHandle] ;
    self.labMark.text = dateStringWithFormatter([NSDate date], @"HHmmss") ;
    [self initView] ;
    [self startReqSiteInfo];
    
}
-(NSMutableArray *)checkDomainServices
{
    if (!_checkDomainServices){
        _checkDomainServices = [[NSMutableArray alloc] init] ;
    }
    return _checkDomainServices ;
}

-(void)cancelAllDomainCheck
{
    for (int i=0; i<self.checkDomainServices.count; i++) {
        RH_ServiceRequest *tmpServiceRequest = ConvertToClassPointer(RH_ServiceRequest, [self.checkDomainServices objectAtIndex:i]) ;
        [tmpServiceRequest cancleAllServices] ;
    }
    [self.checkDomainServices removeAllObjects] ;
}

//showToast
- (void) addToastWithString:(NSString *)string inView:(UIView *)view {

    CGRect initRect = CGRectMake(0, STATUS_BAR_HEIGHT + 44, aiScreenWidth, 0);
    CGRect rect = CGRectMake(0, STATUS_BAR_HEIGHT + 44, aiScreenWidth, 22);
    UILabel* label = [[UILabel alloc] initWithFrame:initRect];
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor colorWithRed:0 green:0.6 blue:0.9 alpha:0.6];

    [view addSubview:label];

    //弹出label
    [UIView animateWithDuration:0.5 animations:^{

        label.frame = rect;

    } completion:^ (BOOL finished){
        //弹出后持续1s
        [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(removeToastWithView:) userInfo:label repeats:NO];
    }];
}

//closeToast
- (void) removeToastWithView:(NSTimer *)timer {
    UILabel* label = [timer userInfo];
    CGRect initRect = CGRectMake(0, STATUS_BAR_HEIGHT + 44, aiScreenWidth, 0);
    //    label消失
    [UIView animateWithDuration:0.5 animations:^{
        label.frame = initRect;
    } completion:^(BOOL finished){
        [label removeFromSuperview];
    }];
}

#pragma mark - 获取 域名 list 并发请求管理器
//- (RH_ConcurrentServicesReqManager *)concurrentServicesManager
//{
//    if (!_concurrentServicesManager) {
//        _concurrentServicesManager = [[RH_ConcurrentServicesReqManager alloc] init];
//        _concurrentServicesManager.delegate = self;
//    }
//
//    return _concurrentServicesManager;
//}

- (void)concurrentServicesManager:(RH_ConcurrentServicesReqManager *)concurrentServicesManager didCompletedAllServiceWithDatas:(NSDictionary *)datas errors:(NSDictionary *)errors
{
    if (errors.count==RH_API_MAIN_URL.count){
        [self.contentLoadingIndicateView hiddenView] ;
        NSError *error = errors.allValues[0] ;
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"系统没有返回可用的域名列表"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"点击重试" style:UIAlertActionStyleDefault                  handler:^(UIAlertAction * action) { //响应事件
            [self repetitionStartReqSiteInfo];
            [self.serviceRequest startUploadAPPErrorMessge:@{@"haha":@"qweqwe"}];
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
//         showAlertView(@"系统提示", @"没有检测到可用的主域名!");
    }
}

#pragma mark-
- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest  serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeDomainList){
        _urlArray = ConvertToClassPointer(NSArray, data) ;
        [self checkAllUrl] ;
    }
    //check 域名成功进入回调
    else if (type == ServiceRequestTypeDomainCheck)
    {
        [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil detailText:@"检查完成,即将进入"];
            RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
                    if ([self.checkType isEqualToString:@"https+8989"]) {
                            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"https://",self.checkDominStr,@":8989"]] ;
                    }else if ([self.checkType isEqualToString:@"http+8787"]){
                            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"http://",self.checkDominStr,@":8787"]] ;
                    }else if ([self.checkType isEqualToString:@"https"]){
                            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"https://",self.checkDominStr,@""]] ;
                    }else if ([self.checkType isEqualToString:@"http"]){
                            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"http://",self.checkDominStr,@""]] ;
                    }
            if (IS_DEV_SERVER_ENV || IS_TEST_SERVER_ENV){
                [self splashViewComplete] ;
            }
            else{
                if ([SITE_TYPE isEqualToString:@"integratedv3oc"] || [SITE_TYPE isEqualToString:@"integratedv3"]) {
                    [self.serviceRequest startV3UpdateCheck];
                }else
                {
                    [self.serviceRequest startUpdateCheck] ;
                }
                
            }
    }else if (type == ServiceRequestTypeUpdateCheck || type == ServiceRequestTypeV3UpdateCheck){
        RH_UpdatedVersionModel *checkVersion = ConvertToClassPointer(RH_UpdatedVersionModel, data) ;
        if(checkVersion.mVersionCode<=[RH_APP_VERCODE integerValue]){
            [self splashViewComplete] ;
            return;
        }
        //检查今天是否已提醒
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSDate *dateTmp = ConvertToClassPointer(NSDate, [userDefaults objectForKey:kUpdateAPPDatePrompt]) ;
        NSDate *dateCurr = [NSDate date] ;
        
        if (dateTmp==nil ||
            [dateCurr timeIntervalSinceDate:dateTmp]>OneDayTotalInterval){
            UIAlertView * alertView = [UIAlertView alertWithCallBackBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if(alertView.firstOtherButtonIndex == buttonIndex){
                    NSString *downLoadIpaUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://%@%@/%@/app_%@_%@.plist",checkVersion.mAppUrl,checkVersion.mVersionName,CODE,CODE,checkVersion.mVersionName];
                    if (openURL(downLoadIpaUrl)==false){
                        [userDefaults setObject:[NSDate date] forKey:kUpdateAPPDatePrompt] ;
                        [self splashViewComplete] ;
                    }else{
                        exit(0) ;
                    }
                }else{
                    [userDefaults setObject:[NSDate date] forKey:kUpdateAPPDatePrompt] ;
                    [self splashViewComplete] ;
                }
                
            }
                                                                    title:@"检测到新版本"
                                                                  message:checkVersion.mMemo
                                                         cancelButtonName:@"暂不更新"
                                                        otherButtonTitles:@"立即更新", nil
                                       ];
            
            [alertView show];
        }else{
            [self splashViewComplete] ;
        } 
    }
}

- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeDomainList){
        [self.contentLoadingIndicateView hiddenView] ;
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"系统没有返回可用的域名列表"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"点击重试" style:UIAlertActionStyleDefault                  handler:^(UIAlertAction * action) { //响应事件
            [self startReqSiteInfo];
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    //check域名失败进入的回调
    else if (type == ServiceRequestTypeDomainCheck)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:RHNT_DomainCheckFail
                                                            object:[ConvertToClassPointer(NSString, [serviceRequest contextForType:ServiceRequestTypeDomainCheck]) copy]] ;
        static int totalFail = 0 ;
        dispatch_async(dispatch_get_main_queue(), ^{
            totalFail ++ ;
            
            if (totalFail>=_urlArray.count){
                [self.contentLoadingIndicateView hiddenView] ;
                
                if (![SITE_TYPE isEqualToString:@"integratedv3oc"])
                {
                    //上传错误信息
                    NSMutableDictionary *dictError = [[NSMutableDictionary alloc] init] ;
                    [dictError setValue:SID forKey:RH_SP_COLLECTAPPERROR_SITEID] ;
                    [dictError setValue:self.labMark.text forKey:RH_SP_COLLECTAPPERROR_MARK] ;
                    [dictError setValue:self.labIPAddr.text?:@"" forKey:RH_SP_COLLECTAPPERROR_IP] ;
                    if ([RH_UserInfoManager shareUserManager].loginUserName.length){
                        [dictError setValue:[RH_UserInfoManager shareUserManager].loginUserName
                                     forKey:RH_SP_COLLECTAPPERROR_USERNAME] ;
                        [dictError setValue:[RH_UserInfoManager shareUserManager].loginTime
                                     forKey:RH_SP_COLLECTAPPERROR_LASTLOGINTIME] ;
                    }
                    NSMutableString *domainList = [[NSMutableString alloc] init] ;
                    NSMutableString *errorCodeList = [[NSMutableString alloc] init] ;
                    NSMutableString *errorMessageList = [[NSMutableString alloc] init] ;
                    for (NSDictionary *dictTmp in [RH_UserInfoManager shareUserManager].domainCheckErrorList) {
                        if (domainList.length){
                            [domainList appendString:@";"] ;
                        }
                        
                        if (errorCodeList.length){
                            [errorCodeList appendString:@";"] ;
                        }
                        
                        if (errorMessageList.length){
                            [errorMessageList appendString:@";"] ;
                        }
                        
                        [domainList appendString:[dictTmp stringValueForKey:RH_SP_COLLECTAPPERROR_DOMAIN]] ;
                        [errorCodeList appendString:[dictTmp stringValueForKey:RH_SP_COLLECTAPPERROR_CODE]] ;
                        [errorMessageList appendString:[dictTmp stringValueForKey:RH_SP_COLLECTAPPERROR_ERRORMESSAGE]] ;
                    }
                    
                    [dictError setValue:domainList forKey:RH_SP_COLLECTAPPERROR_DOMAIN] ;
                    [dictError setValue:errorCodeList forKey:RH_SP_COLLECTAPPERROR_CODE] ;
                    [dictError setValue:errorMessageList forKey:RH_SP_COLLECTAPPERROR_ERRORMESSAGE] ;
                    NSLog(@"dictError====%@",dictError);
                    [self.serviceRequest startUploadAPPErrorMessge:dictError] ;
                }
                
                if (IS_DEV_SERVER_ENV){
#ifdef TEST_DOMAIN
                    [self.appDelegate updateDomain:[NSString stringWithFormat:@"%@",TEST_DOMAIN]] ;
                    [self splashViewComplete] ;
#endif
                }else{
                    [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil detailText:@"正在检查线路,请稍候"] ;
                    if ([self.checkType isEqualToString:@"https+8989"]) {
                        self.checkType = @"http+8787";
                    }
                    else if ([self.checkType isEqualToString:@"http+8787"]){
                        self.checkType = @"https";
                    }
                    else if ([self.checkType isEqualToString:@"https"]){
                        self.checkType = @"http";
                    }
                    else
                    {
                        i++;
                        self.checkType = @"https+8989";
                    }
                    [self checkAllUrl] ;
                }
            }
        });
    }else if (type == ServiceRequestTypeUpdateCheck){
        [self splashViewComplete] ;
    }
    else if (type ==ServiceRequestTypeV3UpdateCheck){
        
    }
}
- (void)checkAllUrl{
    if (_urlArray.count){
        if (IS_DEV_SERVER_ENV || IS_TEST_SERVER_ENV){
            [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil
                                                             detailText:@"checking domain"] ;
        }
        if (IS_TEST_SERVER_ENV==1) {
            //check域名
            NSString *tmpDomain = [_urlArray objectAtIndex:0] ;
            self.checkDominStr = tmpDomain;
            self.serviceRequest.timeOutInterval = 10.f;
            self.checkType = @"http";
            [self.serviceRequest startCheckDomain:tmpDomain WithCheckType:self.checkType];
        }else if(i<_urlArray.count){
            //check域名
            NSString *tmpDomain = [_urlArray objectAtIndex:i] ;
            self.checkDominStr = tmpDomain;
            self.serviceRequest.timeOutInterval = 10.f;
            [self.serviceRequest startCheckDomain:tmpDomain WithCheckType:self.checkType];
        }
        else
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"系统没有返回可用的域名"preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"点击重试" style:UIAlertActionStyleDefault                  handler:^(UIAlertAction * action) { //响应事件
                [self repetitionStartReqSiteInfo];
                [self.serviceRequest startUploadAPPErrorMessge:@{@"haha":@"qweqwe"}];
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        [self.contentLoadingIndicateView hiddenView] ;
        showAlertView( NSLocalizedString(@"ALERT_LOGIN_PROMPT_TITLE", nil), _urlArray.count?NSLocalizedString(@"SPLASHVIEWCTRL_INVALID_DOMAIN", nil):
                      NSLocalizedString(@"SPLASHVIEWCTRL_EMPTY_DOMAINLIST", nil)) ;
    }
}
#pragma mark ==============通知================
-(void)notCheckDominSuccess:(NSNotification*)notification{
    [self checkAllUrl];
}
#pragma mark-
- (void)show:(BOOL)animated completedBlock:(void(^)(void))completedBlock
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.windowLevel = [[UIApplication sharedApplication] keyWindow].windowLevel;
    
    //建立的循环保留
    [self.window setRootViewController:self];
    [self.window makeKeyAndVisible];

    if (animated) {
        self.window.alpha = 0.f;
        [UIView animateWithDuration:0.8f
                         animations:^{
                             self.window.alpha = 1.f;
                         } completion:^(BOOL finished) {

                             [self statusBarAppearanceUpdate];

                             if (completedBlock) {
                                 completedBlock();
                             }
                         }];
    }else {
        [self statusBarAppearanceUpdate];

        if (completedBlock) {
            completedBlock();
        }
    }
}

- (void)hide:(BOOL)animated completedBlock:(void (^)(void))completedBlock
{
    if (!self.window) {
        return;
    }

    if (animated) {

        [UIView animateWithDuration:1.5f animations:^{

            //放大并消失
            self.window.alpha = 0.f;
            self.window.transform = CGAffineTransformMakeScale(2.f, 2.f);

        } completion:^(BOOL finished){

            [self.window setHidden:YES];
            [self.window setRootViewController:nil];
            self.window = nil;

            if (completedBlock) {
                completedBlock();
            }
        }];

    }else{

        [self.window setHidden:YES];
        [self.window setRootViewController:nil];
        self.window = nil;

        if (completedBlock) {
            completedBlock();
        }
    }

}

#pragma mark -
- (void)splashViewComplete
{
    [self.contentLoadingIndicateView hiddenView] ;
    BOOL bRet = YES;
    ifRespondsSelector(self.delegate, @selector(splashViewControllerWillHidden:)) {
        bRet = [self.delegate splashViewControllerWillHidden:self];
    }
    if (bRet) {
        [self hide:YES completedBlock:nil];
    }
    //check过了，就把通知释放掉
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"youAreNotCheckSuccess" object:nil];
}

#pragma mark -
- (BOOL)shouldAutorotate {
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#else
- (NSUInteger)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
