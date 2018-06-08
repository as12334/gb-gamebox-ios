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
#import "RH_AdvertisingView.h"
#import "ErrorStateTopView.h"
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
@property (weak, nonatomic) IBOutlet UITableView *domainTableView   ;
@property (nonatomic,strong,readonly) NSMutableArray *domainCheckStatusList ;
@property (nonatomic,strong) NSString *checkType;
//check到的域名
@property (nonatomic,strong)NSString *checkDominStr;
//启动页进度条
@property(nonatomic,strong,readonly)UIProgressView *progressView;
//显示进度条进度
@property(nonatomic,strong,readonly)UILabel *scheduleLabel;
//check的状态
@property(nonatomic,strong,readonly)UILabel *checkStatusLabel;
//重新check的按钮
@property(nonatomic,strong)UIButton *againBtn;
@property(nonatomic,readonly,strong)RH_ServiceRequest *serviceRequest;
@end

@implementation SplashViewController
{
    NSArray *_urlArray ;
    NSString *_talk ;
    int i;
    bool isMaintain ;
}
@synthesize checkDomainServices = _checkDomainServices ;
@synthesize domainCheckStatusList = _domainCheckStatusList ;
@synthesize serviceRequest = _serviceRequest;
@synthesize progressView = _progressView;
@synthesize scheduleLabel = _scheduleLabel;
@synthesize checkStatusLabel = _checkStatusLabel;
-(RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest) {
        _serviceRequest = [[RH_ServiceRequest alloc]init];
        _serviceRequest.delegate = self;
    }
    return _serviceRequest;
}
-(UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.frame = CGRectMake((MainScreenW-200)/2,MainScreenH-50, 200, 10);
        //进度条颜色
        _progressView.progressTintColor = [UIColor blueColor];
        //进度条未完成颜色
        _progressView.trackTintColor = [UIColor lightGrayColor];
        _progressView.progress = 0;
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
    }
    return _progressView;
}
-(UILabel *)scheduleLabel
{
    if (!_scheduleLabel) {
        _scheduleLabel = [[UILabel alloc]initWithFrame:CGRectMake((MainScreenW-50)/2,MainScreenH-70, 50, 10)];
        _scheduleLabel.textColor = [UIColor clearColor];
        _scheduleLabel.text = @"0%";
        _scheduleLabel.font = [UIFont systemFontOfSize:10];
        _scheduleLabel.textColor = [UIColor cyanColor];
        _scheduleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _scheduleLabel;
}
-(UILabel *)checkStatusLabel
{
    if (!_checkStatusLabel) {
        _checkStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake((MainScreenW-150)/2,MainScreenH-90, 150, 10)];
        _checkStatusLabel.textColor = [UIColor clearColor];
        _checkStatusLabel.text = @"正在匹配服务器，请稍后...";
        _checkStatusLabel.font = [UIFont systemFontOfSize:10];
        _checkStatusLabel.textColor = [UIColor cyanColor];
        _checkStatusLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _checkStatusLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    i = 0;
    _talk = @"/__check" ;
    self.hiddenNavigationBar = YES ;
    self.hiddenStatusBar = YES ;
    self.hiddenTabBar = YES ;
    isMaintain = NO;
    if (IS_DEV_SERVER_ENV || IS_TEST_SERVER_ENV)
    {
#ifdef TEST_DOMAIN
        _urlArray = @[TEST_DOMAIN] ;
        [self.appDelegate updateApiDomain:ConvertToClassPointer(NSString, [RH_API_MAIN_URL objectAtIndex:0])] ;
#endif
    }
    self.needObserveNetStatusChanged = YES ;
//    [self netStatusChangedHandle] ;
    self.labMark.text = dateStringWithFormatter([NSDate date], @"HHmmss") ;
    [self initView] ;
//    [self performSelector:@selector(startReqSiteInfo) withObject:nil afterDelay:1];
    [self startReqSiteInfo];
    //注册打开是否check成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notCheckDominSuccess:) name:@"youAreNotCheckSuccess" object:nil];
    //加入进度条
    [self.view addSubview:self.progressView];
    //
    [self.view addSubview:self.scheduleLabel];
    //加载说明
    [self.view addSubview:self.checkStatusLabel];
}

- (void)initView{
    //设置启动页logo
    NSString *logoName = [NSString stringWithFormat:@"app_logo_%@",SID] ;
    [self.splashLogo setImage:ImageWithName(logoName)];
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

}

-(void)startReqSiteInfo
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil detailText:@"正在检查线路,请稍候"] ;
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
//    [self netStatusChangedHandle] ;
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
#pragma mark-
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
#pragma mark-
- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest  serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeDomainList){
        NSDictionary *dict = ConvertToClassPointer(NSDictionary, data);
        _urlArray = ConvertToClassPointer(NSArray, [dict objectForKey:@"ips"]);
//        _urlArray = @[@"19.0.4.5",@"123.45.23.6",@"54.56.87.4",@"192.168.0.9"];
        [self.appDelegate updateHeaderDomain:[data objectForKey:@"domain"]];
        [self checkAllUrl] ;
    }else if (type == ServiceRequestTypeDomainCheck)
    {
        [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil detailText:@"检查完成,即将进入"];
        self.progressView.progress = 1.0;
        self.scheduleLabel.text = @"100%";
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        if ([appDelegate.checkType isEqualToString:@"https+8989"]) {
            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"https://",self.checkDominStr,@":8989"]] ;
        }else if ([appDelegate.checkType isEqualToString:@"http+8787"]){
            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"http://",self.checkDominStr,@":8787"]] ;
        }else if ([appDelegate.checkType isEqualToString:@"https"]){
            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"https://",self.checkDominStr,@""]] ;
        }else if ([appDelegate.checkType isEqualToString:@"http"]){
            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"http://",self.checkDominStr,@""]] ;
        }
        if (IS_TEST_SERVER_ENV){
            [self splashViewComplete] ;
        }else{
            if ([SITE_TYPE isEqualToString:@"integratedv3oc"] || [SITE_TYPE isEqualToString:@"integratedv3"]) {
                [self.serviceRequest startV3UpdateCheck];
            }else
            {
                [self.serviceRequest startUpdateCheck] ;
            }
            
        }
    }else if (type == ServiceRequestTypeUpdateCheck || type == ServiceRequestTypeV3UpdateCheck){
        RH_UpdatedVersionModel *checkVersion = ConvertToClassPointer(RH_UpdatedVersionModel, data) ;
        //检查今天是否已提醒
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSDate *dateTmp = ConvertToClassPointer(NSDate, [userDefaults objectForKey:kUpdateAPPDatePrompt]) ;
        NSDate *dateCurr = [NSDate date] ;
        if(checkVersion.mVersionCode<=[RH_APP_VERCODE integerValue]&&[checkVersion.mForceVersion integerValue]<=[RH_APP_VERCODE integerValue]){
            [self splashViewComplete] ;
            return;
        }
        else if (checkVersion.mVersionCode>[RH_APP_VERCODE integerValue]&&[checkVersion.mForceVersion integerValue]<=[RH_APP_VERCODE integerValue]){
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
        else if (checkVersion.mVersionCode>[RH_APP_VERCODE integerValue]&&[checkVersion.mForceVersion integerValue]>[RH_APP_VERCODE integerValue])
        {
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
                        exit(0);
                    }
                    
                }
                                                                        title:@"检测到新版本"
                                                            message:checkVersion.mMemo
                                                             cancelButtonName:@"退出"
                                                            otherButtonTitles:@"立即更新", nil
                                           ];
                [alertView show];
            }else{
                [self splashViewComplete] ;
            }
        }
    }
}

- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeDomainList){
        [self.contentLoadingIndicateView hiddenView] ;
        showAlertView(@"系统提示", @"没有检测到可用的主域名!");
    }else if (type == ServiceRequestTypeDomainCheck)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:RHNT_DomainCheckFail
                                                            object:[ConvertToClassPointer(NSString, [serviceRequest contextForType:ServiceRequestTypeDomainCheck]) copy]] ;
        static int totalFail = 0 ;
        dispatch_async(dispatch_get_main_queue(), ^{
            totalFail ++ ;
            if (totalFail>=_urlArray.count){
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
                    
                }
            }
        });
        
        [self.domainTableView reloadData] ;
    }else if (type == ServiceRequestTypeUpdateCheck){
        [self splashViewComplete] ;
    }
}

- (void)checkAllUrl{
    if (_urlArray.count){
        if (IS_DEV_SERVER_ENV || IS_TEST_SERVER_ENV){
            [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil
                                                             detailText:@"正在检查线路,请稍候"] ;
        }
        if (IS_TEST_SERVER_ENV==1||IS_DEV_SERVER_ENV==1) {
            //check域名
            NSString *tmpDomain = [_urlArray objectAtIndex:0] ;
            self.checkDominStr = tmpDomain;
            self.serviceRequest.timeOutInterval = 10.f;
            self.checkType = @"http";
            [self.serviceRequest startCheckDomain:tmpDomain WithCheckType:@"http"];
        }else if(i<_urlArray.count){
            //check域名
            NSString *tmpDomain = [_urlArray objectAtIndex:i] ;
            self.checkDominStr = tmpDomain;
            self.serviceRequest.timeOutInterval = 10.f;
            dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //2.添加任务到队列中，就可以执行任务
            //异步函数：具备开启新线程的能力
            dispatch_async(queue, ^{
               [self.serviceRequest startCheckDomain:tmpDomain WithCheckType:@"https+8989"];
            });
            dispatch_async(queue, ^{
                [self.serviceRequest startCheckDomain:tmpDomain WithCheckType:@"http+8787"];
            });
            dispatch_async(queue, ^{
               [self.serviceRequest startCheckDomain:tmpDomain WithCheckType:@"https"];
            });
            dispatch_async(queue, ^{
                [self.serviceRequest startCheckDomain:tmpDomain WithCheckType:@"http"];
            });
        }
        else
        {
             [self.contentLoadingIndicateView hiddenView] ;
            //隐藏进度条
           [self.progressView removeFromSuperview];
            //
            [self.scheduleLabel removeFromSuperview];
            //加载说明
            [self.checkStatusLabel setText:@"匹配服务器失败"];
            _againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _againBtn.frame = CGRectMake((MainScreenW-100)/2, MainScreenH-60, 100, 40);
            _againBtn.backgroundColor = [UIColor yellowColor];
            [_againBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_againBtn setTitle:@"重新匹配" forState:UIControlStateNormal];
            _againBtn.layer.cornerRadius = 10.f;
            _againBtn.layer.masksToBounds = YES;
            [_againBtn addTarget:self action:@selector(againCheckClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_againBtn];
        }
    }else{
        [self.contentLoadingIndicateView hiddenView] ;
        showAlertView( NSLocalizedString(@"ALERT_LOGIN_PROMPT_TITLE", nil), _urlArray.count?NSLocalizedString(@"SPLASHVIEWCTRL_INVALID_DOMAIN", nil):
                      NSLocalizedString(@"SPLASHVIEWCTRL_EMPTY_DOMAINLIST", nil)) ;
    }
}
#pragma mark ==============通知================
-(void)notCheckDominSuccess:(NSNotification*)notification{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil detailText:@"正在检查线路,请稍候"] ;
    i++;
    self.progressView.progress+=(1.0/_urlArray.count);
    self.scheduleLabel.text = [NSString stringWithFormat:@"%0.f%%",self.progressView.progress*100];
    [self checkAllUrl];
}
-(void)againCheckClick
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil
                                                     detailText:@"正在检查线路,请稍后"];
    //加入进度条
    [self.view addSubview:self.progressView];
    self.progressView.progress = 0.f;
    //
    [self.view addSubview:self.scheduleLabel];
    [self.scheduleLabel setText:@"0%"];
    //加载说明
    [self.checkStatusLabel setText:@"正在匹配服务器，请稍后..."];
    [self.againBtn removeFromSuperview];
    i= 0;
    [self repetitionStartReqSiteInfo];
    
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

#pragma mark -tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.domainCheckStatusList.count ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RH_DomainTableCell heightForCellWithInfo:nil tableView:nil context:nil] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _DoMainCheckStatusModel *checkModel = self.domainCheckStatusList[indexPath.item] ;
    RH_DomainTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[RH_DomainTableCell defaultReuseIdentifier]] ;
    [cell updateCellWithInfo:@{@"title":checkModel.doMain,
                               @"detailTitle":checkModel.showStatus}
                     context:nil] ;
    
    return cell ;
}

#pragma mark -
- (void)splashViewComplete
{
    [self.contentLoadingIndicateView hiddenView] ;
    if (isMaintain==NO) {
        __block SplashViewController *weakSelf = self;
        RH_AdvertisingView *advertising = [RH_AdvertisingView ceareAdvertisingView:@"https://www.baidu.com"];
        [self.view addSubview:advertising];
        advertising.block = ^{
            BOOL bRet = YES;
            ifRespondsSelector(self.delegate, @selector(splashViewControllerWillHidden:)) {
                bRet = [weakSelf.delegate splashViewControllerWillHidden:self];
            }
            if (bRet) {
                //启动页加载完成后跳转
                [weakSelf hide:YES completedBlock:nil];
            }
        };
        //check过了，就把通知释放掉
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"youAreNotCheckSuccess" object:nil];
    }
    else if (isMaintain==YES){
        ErrorStateTopView *errorView = [[ErrorStateTopView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:errorView];
    }
}
#pragma mark ==============通知================
-(void)tongzhi:(NSNotification *)notification
{
    isMaintain = NO;
    [self splashViewComplete];
    
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
