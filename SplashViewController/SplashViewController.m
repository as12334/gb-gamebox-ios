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
//#pragma mark ==============懒加载，重试按钮================
//-(UIButton *)padonBtn
//{
//    if (!_padonBtn) {
//        _padonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _padonBtn.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//    }
//}
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


@interface SplashViewController ()<RH_ServiceRequestDelegate,RH_ConcurrentServicesReqManagerDelegate>
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

//获取 域名 list 并发请求管理器
@property(nonatomic,strong,readonly) RH_ConcurrentServicesReqManager * concurrentServicesManager;
@end

@implementation SplashViewController
{
    NSArray *_urlArray ;
    NSString *_talk ;
}
@synthesize checkDomainServices = _checkDomainServices ;
@synthesize domainCheckStatusList = _domainCheckStatusList ;
@synthesize concurrentServicesManager = _concurrentServicesManager ;

-(void)viewWillAppear:(BOOL)animated
{
    self.checkType = @"https+8989";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self netStatusChangedHandle] ;
    self.labMark.text = dateStringWithFormatter([NSDate date], @"HHmmss") ;
    [self initView] ;
    
    
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
//    self.domainTableView.dataSource = self ;
//    self.domainTableView.delegate = self ;
    self.domainTableView.hidden = YES ;
}

-(void)startReqSiteInfo
{
    [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil detailText:@"正在检查线路,请稍候"] ;
    [self.concurrentServicesManager cancleAllServices] ;
    for (int i=0; i<RH_API_MAIN_URL.count; i++) {
        NSString *strTmp = ConvertToClassPointer(NSString, [RH_API_MAIN_URL objectAtIndex:i]) ;
        [self.concurrentServicesManager createServiceRequestAddToManagerWithKey:[NSString stringWithFormat:@"%d",i]
                                                                   requestBlock:^(RH_ServiceRequest *serviceRequest) {
            [serviceRequest startReqDomainListWithDomain:strTmp.trim] ;
        }];
    }
   [self.concurrentServicesManager startManagerRequests];
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

#pragma mark -
-(NSMutableArray *)domainCheckStatusList
{
    if (!_domainCheckStatusList){
        _domainCheckStatusList = [NSMutableArray array] ;
    }
    
    return _domainCheckStatusList ;
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

#pragma mark - 获取 域名 list 并发请求管理器
- (RH_ConcurrentServicesReqManager *)concurrentServicesManager
{
    if (!_concurrentServicesManager) {
        _concurrentServicesManager = [[RH_ConcurrentServicesReqManager alloc] init];
        _concurrentServicesManager.delegate = self;
    }
    
    return _concurrentServicesManager;
}

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

- (void)concurrentServicesManager:(RH_ConcurrentServicesReqManager *)concurrentServicesManager
                   serviceRequest:(RH_ServiceRequest *)serviceRequest
                              key:(NSString *)key
                      serviceType:(ServiceRequestType)type
        didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeDomainList){
        static dispatch_once_t onceToken ;
        dispatch_once(&onceToken, ^{
            _urlArray = ConvertToClassPointer(NSArray, data) ;
//            _urlArray = @[@"xaxaxa.com"];
            [self.appDelegate updateApiDomain:ConvertToClassPointer(NSString, [RH_API_MAIN_URL objectAtIndex:key.intValue])] ;
            [self checkAllUrl] ;
        }) ;
    }
}

#pragma mark-
- (void) serviceRequest:(RH_ServiceRequest *)serviceRequest  serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeDomainList){
        _urlArray = ConvertToClassPointer(NSArray, data) ;
        [self checkAllUrl] ;
    }else if (type == ServiceRequestTypeDomainCheck)
    {
        [self.contentLoadingIndicateView showLoadingStatusWithTitle:nil detailText:@"检查完成,即将进入"];
        [[NSNotificationCenter defaultCenter] postNotificationName:RHNT_DomainCheckSuccessful
                                                            object:[ConvertToClassPointer(NSString, [serviceRequest contextForType:ServiceRequestTypeDomainCheck]) copy]] ;
        static dispatch_once_t onceToken ;
        dispatch_once(&onceToken, ^{
            NSString *strTmp =  [ConvertToClassPointer(NSString, [serviceRequest contextForType:ServiceRequestTypeDomainCheck]) copy] ;
            RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
//            if ([self.checkType isEqualToString:@"https+8989"]) {
                if (![data boolValue])//http protocol
                {
                    if ([self.checkType isEqualToString:@"https+8989"]) {
                        if ([data boolValue])//http protocol
                        {
                            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"https://",strTmp,@":8989"]] ;
                        }
                    }else if ([self.checkType isEqualToString:@"http+8787"]){
                        if ([data boolValue])//http protocol
                        {
                            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"http://",strTmp,@":8787"]] ;
                        }
                    }else if ([self.checkType isEqualToString:@"https"]){
                        if ([data boolValue])//http protocol
                        {
                            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"https://",strTmp,@""]] ;
                        }
                    }else{
                        if ([data boolValue])//http protocol
                        {
                            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"http://",strTmp,@""]] ;
                        }
                    }
                    
                }else{
                    if ([self.checkType isEqualToString:@"https+8989"]) {
                        if ([data boolValue])//http protocol
                        {
                            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"https://",strTmp,@":8989"]] ;
                        }
                    }else if ([self.checkType isEqualToString:@"http+8787"]){
                        if ([data boolValue])//http protocol
                        {
                            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"http://",strTmp,@":8787"]] ;
                        }
                    }else if ([self.checkType isEqualToString:@"https"]){
                        if ([data boolValue])//http protocol
                        {
                            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"https://",strTmp,@""]] ;
                        }
                    }else{
                        if ([data boolValue])//http protocol
                        {
                            [appDelegate updateDomain:[NSString stringWithFormat:@"%@%@%@",@"http://",strTmp,@""]] ;
                        }
                    }
                }
//            }
            
            
            [self cancelAllDomainCheck] ;
        
            if (IS_DEV_SERVER_ENV || IS_TEST_SERVER_ENV){
                [self splashViewComplete] ;
            }else{
                if ([SITE_TYPE isEqualToString:@"integratedv3oc"] || [SITE_TYPE isEqualToString:@"integratedv3"]) {
                    [self.serviceRequest startV3UpdateCheck];
//                    [self.serviceRequest startV3customSysDomain];
                    
                }else
                {
                    [self.serviceRequest startUpdateCheck] ;
                }
                
            }
        }) ;
        
        [self.domainTableView reloadData] ;
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
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"系统没有返回可用的域名列表"preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"点击重试" style:UIAlertActionStyleDefault                  handler:^(UIAlertAction * action) { //响应事件
//            [self startReqSiteInfo];
//        }];
//        [alert addAction:defaultAction];
//        [self presentViewController:alert animated:YES completion:nil];
//         showAlertView(@"系统提示", @"没有检测到可用的主域名!");
        showMessage(self.view, @"", @"正在检测线路");
        if ([self.checkType isEqualToString:@"https+8989"]) {
            self.checkType = @"http+8787";
        }else if ([self.checkType isEqualToString:@"http+8787"]){
            self.checkType = @"https";
        }else if ([self.checkType isEqualToString:@"https"]){
            self.checkType = @"http";
        }
        [self checkAllUrl] ;
    }else if (type == ServiceRequestTypeDomainCheck)
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
                    [self.appDelegate updateDomain:[NSString stringWithFormat:@"%@%@",@"https://",TEST_DOMAIN]] ;
                    [self splashViewComplete] ;
#endif
                }else{
                    
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"没有检测到可用的主域名!"preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"点击重试" style:UIAlertActionStyleDefault                  handler:^(UIAlertAction * action) { //响应事件
                        [self repetitionStartReqSiteInfo];
                         [self.serviceRequest startUploadAPPErrorMessge:@{@"haha":@"qweqwe"}];
                    }];
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
//                    showAlertView(@"系统提示", @"没有检测到可用的主域名!");
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
                                                             detailText:@"checking domain"] ;
        }
        
        for (int i=0; i<_urlArray.count; i++) {
            NSString *tmpDomain = [_urlArray objectAtIndex:i] ;
            RH_ServiceRequest *tmpServiceRequest = [[RH_ServiceRequest alloc] init] ;
            tmpServiceRequest.delegate = self ;
            [tmpServiceRequest setContext:tmpDomain forType:ServiceRequestTypeDomainCheck] ;
            [self.checkDomainServices addObject:tmpServiceRequest] ;
            tmpServiceRequest.timeOutInterval = 10.0f ;
            
            [tmpServiceRequest startCheckDomain:tmpDomain WithCheckType:self.checkType] ;
            [self.domainCheckStatusList addObject:[[_DoMainCheckStatusModel alloc] initWithDomain:tmpDomain Status:doMainStatus_Checking]] ;
            
        }
        
        //显示检测的域名 ---
        [self.domainTableView reloadData] ;
        
    }else{
        [self.contentLoadingIndicateView hiddenView] ;
        showAlertView( NSLocalizedString(@"ALERT_LOGIN_PROMPT_TITLE", nil), _urlArray.count?NSLocalizedString(@"SPLASHVIEWCTRL_INVALID_DOMAIN", nil):
                      NSLocalizedString(@"SPLASHVIEWCTRL_EMPTY_DOMAINLIST", nil)) ;
    }
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
    BOOL bRet = YES;
    ifRespondsSelector(self.delegate, @selector(splashViewControllerWillHidden:)) {
        bRet = [self.delegate splashViewControllerWillHidden:self];
    }

    if (bRet) {
        [self hide:YES completedBlock:nil];
    }
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
