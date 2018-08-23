//
//  StartPageViewController.m
//  gameBoxEx
//
//  Created by shin on 2018/6/17.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "StartPageViewController.h"
#import "IPsCacheManager.h"
#import "RH_ServiceRequest.h"
#import "RH_APPDelegate.h"
#import "MacroDef.h"
#import "RH_UpdatedVersionModel.h"
#import "coreLib.h"
#import "UpdateStatusCacheManager.h"
#import "RH_API.h"
#import "RH_UserInfoManager.h"
#import <sys/utsname.h>
#import "RH_InitAdModel.h"
#import "RH_StartPageADView.h"
#import "CheckTimeManager.h"

@interface StartPageViewController ()
@property (nonatomic, strong) NSString *progressNote;
@property (nonatomic, assign) CGFloat progress;

@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UILabel *cRightsLB;
@property (weak, nonatomic) IBOutlet UILabel *versionLB;
@property (weak, nonatomic) IBOutlet UILabel *progressNoteLB;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;

@property (strong, nonatomic) UIButton *doitAgainBT;
@property (strong, nonatomic) UIButton *errDetailBT;
@property (strong, nonatomic) NSString *currentErrCode;
@property (strong, nonatomic) NSMutableArray *ipCheckErrorList;
@property (strong, nonatomic) RH_StartPageADView *adView;

@end

@implementation StartPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self doRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doItAgainAction:(id)sender {
    self.doitAgainBT.enabled = NO;
    self.errDetailBT.enabled = NO;
    [self doRequest];
}

- (void)errDetailAction:(id)sender {
    [self showErrAlertWithErrCode:self.currentErrCode otherInfo:nil];
}

#pragma mark - Private M

- (void)setupUI
{
    self.hiddenStatusBar = YES;
    self.hiddenNavigationBar = YES;
    
    [self.launchImageView setImage:ImageWithName(@"startImage")];
    [self.logoImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"app_logo_%@",SID]]];
    if ([SID intValue] == 119 || [SID intValue] == 270 || [SID intValue] == 136 || [SID intValue] == 211) {
        self.logoImg.hidden = YES;
    }
    else
    {
        self.logoImg.hidden = NO;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [self.cRightsLB setText:[NSString stringWithFormat:@"Copyrihgt © %@ Reserved.",app_Name]];
    [self.versionLB setText:[NSString stringWithFormat:@"v%@",app_Version]];
    
    self.doitAgainBT.layer.cornerRadius = 10.0;
    self.doitAgainBT.clipsToBounds = YES;
    self.errDetailBT.layer.cornerRadius = 10.0;
    self.errDetailBT.clipsToBounds = YES;
}

- (RH_StartPageADView *)adView
{
    if (_adView == nil) {
        _adView = [[[NSBundle mainBundle] loadNibNamed:@"RH_StartPageADView" owner:nil options:nil] lastObject];
        _adView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self.view addSubview:_adView];
    }
    return _adView;
}

- (NSMutableArray *)ipCheckErrorList
{
    if (_ipCheckErrorList == nil) {
        _ipCheckErrorList = [NSMutableArray array];
    }
    return _ipCheckErrorList;
}

- (void)setProgressNote:(NSString *)progressNote
{
    _progressNote = progressNote;
    self.progressNoteLB.text = _progressNote;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.progressView.hidden = (_progress == 0);
    self.doitAgainBT.hidden = (_progress != 0);
    self.errDetailBT.hidden = (_progress != 0);
    self.doitAgainBT.enabled = (_progress == 0);
    self.errDetailBT.enabled = (_progress == 0);
    self.progressView.progress = _progress;
    if (_progress == 0) {
        self.progressNote = @"";
    }
}


- (UIButton *)doitAgainBT
{
    if (_doitAgainBT == nil) {
        _doitAgainBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _doitAgainBT.backgroundColor = colorWithRGB(68, 162, 45);
        [_doitAgainBT setTitleColor:colorWithRGB(255, 255, 255) forState:UIControlStateNormal];
        [_doitAgainBT setTitle:@"线路检测" forState:UIControlStateNormal];
        _doitAgainBT.frame = CGRectMake(0, 0, 100, 33);
        _doitAgainBT.titleLabel.font = [UIFont systemFontOfSize:15];
        _doitAgainBT.hidden = YES;
        [self.view addSubview:_doitAgainBT];
        [self.view bringSubviewToFront:_doitAgainBT];
        _doitAgainBT.whc_CenterYToView(0, self.progressView).whc_CenterXToView(-55, self.view).whc_Width(100).whc_Height(33);
        
        _doitAgainBT.center = self.progressView.center;
        [_doitAgainBT addTarget:self action:@selector(doItAgainAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doitAgainBT;
}

- (UIButton *)errDetailBT
{
    if (_errDetailBT == nil) {
        _errDetailBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _errDetailBT.backgroundColor = colorWithRGB(68, 162, 45);
        [_errDetailBT setTitleColor:colorWithRGB(255, 255, 255) forState:UIControlStateNormal];
        [_errDetailBT setTitle:@"检测结果" forState:UIControlStateNormal];
        _errDetailBT.titleLabel.font = [UIFont systemFontOfSize:15];
        _errDetailBT.hidden = YES;
        [self.view addSubview:_errDetailBT];
        [self.view bringSubviewToFront:_errDetailBT];
        _errDetailBT.whc_CenterYToView(0, self.doitAgainBT).whc_LeftSpaceToView(10, self.doitAgainBT).whc_Width(100).whc_Height(33);
        
        _errDetailBT.center = self.progressView.center;
        [_errDetailBT addTarget:self action:@selector(errDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _errDetailBT;
}

//先从三个固定的链接获取动态ip地址
//该动态ip地址用于获取check ip列表
//以此减轻服务端压力

- (void)fetchHost:(GBFetchHostComplete)complete failed:(GBFetchHostFailed)failed
{
    self.progressNote = @"正在获取服务器列表...";
    self.progress += 0.1;
    NSArray *hosts = @[@"http://203.107.1.33/194768/d?host=apiplay.info",
                       @"http://203.107.1.33/194768/d?host=hpdbtopgolddesign.com",
                       @"http://203.107.1.33/194768/d?host=agpicdance.info"
                       ];
    //将此数据随机打乱 减轻服务器压力
    hosts = [hosts sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    
    //【串行】获取动态host
    __weak typeof(self) weakSelf = self;
    __block BOOL doNext = YES;
    __block int failTimes = 0;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("gb_fetchHost_queue", NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    
    for (NSString *host in hosts) {
        dispatch_group_async(group, queue, ^{
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            if (doNext != YES) {
                //先检测是否需要继续执行 不需要执行则直接跳过本线程
                dispatch_semaphore_signal(sema);
                return ;
            }
            NSLog(@">>>start fetch Host from %@",host);
            
            [weakSelf.serviceRequest fetchHost:host];
            weakSelf.serviceRequest.successBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, id data) {
                if (type == ServiceRequestTypeFetchHost) {
                    if (data) {
                        //已从%@获取到HOST，执行回调
                        NSDictionary *hostDic = ConvertToClassPointer(NSDictionary, data);
                        if (hostDic) {
                            NSLog(@"已从%@获取到HOST，执行回调",host);
                            if (complete) {
                                complete(hostDic);
                            }
                            doNext = NO;
                            weakSelf.progress += 0.1;
                        }
                        else
                        {
                            NSLog(@"从%@未获取到Host，继续下一次获取...",host);
                            doNext = YES;
                            failTimes++;
                            weakSelf.progress += 0.1;
                            if (failTimes == hosts.count) {
                                if (failed) {
                                    failed();
                                }
                            }
                        }
                    }
                    else
                    {
                        NSLog(@"从%@未获取到Host，继续下一次获取...",host);
                        doNext = YES;
                        failTimes++;
                        weakSelf.progress += 0.1;
                        if (failTimes == hosts.count) {
                            if (failed) {
                                failed();
                            }
                        }
                    }
                    dispatch_semaphore_signal(sema);
                }
            };
            weakSelf.serviceRequest.failBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, NSError *error) {
                if (type == ServiceRequestTypeFetchHost) {
                    NSLog(@"从%@未获取到Host，继续下一次获取...",host);
                    doNext = YES;
                    weakSelf.progress += 0.1;
                    failTimes++;
                    if (failTimes == hosts.count) {
                        if (failed) {
                            failed();
                        }
                    }
                    dispatch_semaphore_signal(sema);
                }
            };
        });
    }
}

- (void)doRequest
{
    __weak typeof(self) weakSelf = self;
    self.serviceRequest.timeOutInterval = 5.0;
    
    //先检测缓存中的ips
    BOOL isIPsValid = [[IPsCacheManager sharedManager] isIPsValid];
    if (isIPsValid) {
        self.progress = 0.3;
        //如果还有效 则直接check缓存的ip
        NSDictionary *ips = [[IPsCacheManager sharedManager] ips];
        NSArray *ipList = ConvertToClassPointer(NSArray, [[ips objectForKey:@"ips"] objectForKey:@"ips"]);
        
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        [appDelegate updateApiDomain:[ips objectForKey:@"apiDomain"]];
        [appDelegate updateHeaderDomain:[[ips objectForKey:@"ips"] objectForKey:@"domain"]];
        
        //check iplist
        self.progressNote = @"正在匹配服务器...";
        [self checkAllIP:ipList complete:^{
            [weakSelf startPageComplete];
        } failed:^{
            weakSelf.currentErrCode = @"003";
        }];
        return;
    }
    
    //测试环境使用配置的固定域名
    //不需要去DNS获取动态bossapi
    if (IS_DEV_SERVER_ENV) {
        NSMutableArray *hostUrlArr = [NSMutableArray arrayWithArray:RH_API_MAIN_URL] ;
        self.progressNote = @"正在检查线路,请稍候";
        
        //从动态域名列表依次尝试获取ip列表
        [self fetchIPs:hostUrlArr host:@"" complete:^(NSDictionary *ips) {
            weakSelf.progress = 0.3;
            
            //从某个固定域名列表获取到了ip列表
            //根据优先级并发check
            /**
             * 优先级
             * 1 https+8989
             * 2 http+8787
             * 3 https
             * 4 http
             */
            NSString *resultDomain = [ips objectForKey:@"domain"];
            RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
            [appDelegate updateHeaderDomain:resultDomain];
            
            NSArray *ipList = [ips objectForKey:@"ips"];
            
            //多ip地址【异步并发】check 但check的优先级是【串行】的
            //使用NSOperationQueue 方便取消后续执行
            
            //check iplist
            weakSelf.progressNote = @"正在匹配服务器...";
            [weakSelf checkAllIP:ipList complete:^{
                [weakSelf startPageComplete];
            } failed:^{
                weakSelf.currentErrCode = @"003";
            }];
        } failed:^{
            //从所有的固定域名列表没有获取到ip列表
            weakSelf.progress = 0;
            weakSelf.currentErrCode = @"002";
        }];
    }
    else
    {
        //先从获取动态HOST
        [self fetchHost:^(NSDictionary *host) {
            //缓存bossApi
            [[IPsCacheManager sharedManager] updateBossApiList:host];
            
            NSString *hostName = [host objectForKey:@"host"];
            
            //将此数据随机打乱 减轻服务器压力
            NSArray *hostips = [host objectForKey:@"ips"];
            hostips = [hostips sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
                int seed = arc4random_uniform(2);
                if (seed) {
                    return [str1 compare:str2];
                } else {
                    return [str2 compare:str1];
                }
            }];
            
            NSMutableArray *hostUrlArr = [NSMutableArray array];
            for (NSString *hostip in hostips) {
                NSString *hostUrl = [NSString stringWithFormat:@"https://%@:1344/boss-api",hostip];
                [hostUrlArr addObject:hostUrl];
            }
            
            weakSelf.progressNote = @"正在检查线路,请稍候";
            
            //从动态域名列表依次尝试获取ip列表
            [weakSelf fetchIPs:hostUrlArr host:hostName complete:^(NSDictionary *ips) {
                weakSelf.progress = 0.3;
                
                //从某个固定域名列表获取到了ip列表
                //根据优先级并发check
                /**
                 * 优先级
                 * 1 https+8989
                 * 2 http+8787
                 * 3 https
                 * 4 http
                 */
                NSString *resultDomain = [ips objectForKey:@"domain"];
                RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
                [appDelegate updateHeaderDomain:resultDomain];
                
                NSArray *ipList = [ips objectForKey:@"ips"];
                
                //多ip地址【异步并发】check 但check的优先级是【串行】的
                //使用NSOperationQueue 方便取消后续执行
                
                //check iplist
                weakSelf.progressNote = @"正在匹配服务器...";
                [weakSelf checkAllIP:ipList complete:^{
                    [weakSelf startPageComplete];
                } failed:^{
                    weakSelf.currentErrCode = @"003";
                }];
            } failed:^{
                //从所有的固定域名列表没有获取到ip列表
                weakSelf.progress = 0;
                weakSelf.currentErrCode = @"002";
            }];
        } failed:^{
            weakSelf.progress = 0;
            weakSelf.currentErrCode = @"001";
        }];
    }
}

/**
 * 从固定的域名列表【串行】尝试获取ip列表
 
 @param domains 动态的域名
 */
- (void)fetchIPs:(NSArray *)domains host:(NSString *)host complete:(GBFetchIPsComplete)complete failed:(GBFetchIPsFailed)failed
{
    __weak typeof(self) weakSelf = self;
    __block NSDictionary *resultIPs;
    __block int failedTimes = 0;//失败次数
    
    //是否需要通过下一个固定域名请求ips
    //当前域名获取ips失败时需要从下一个获取
    __block BOOL doNext = YES;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("gb_fetchIPs_queue", NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    
    for (NSString *domain in domains) {
        dispatch_group_async(group, queue, ^{
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            if (doNext != YES) {
                //先检测是否需要继续执行 不需要执行则直接跳过本线程
                dispatch_semaphore_signal(sema);
                return ;
            }
            NSLog(@">>>start fetch url from %@",domain);
            [weakSelf fetchIPListFrom:domain host:host complete:^(NSDictionary *ips) {
                NSLog(@"已从%@获取到ip，执行回调",domain);
                //todo
                //test data
//                                ips = @{@"domain":@"test71.hongtubet.com",@"ips":@[@"47.90.51.75"]};
                resultIPs = ips;
                doNext = NO;//已经获取到ip 不需要继续执行其他的线程
                
                ///
                //缓存ips和apiDomain
                RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
                [appDelegate updateApiDomain:domain];
                
                [[IPsCacheManager sharedManager] updateIPsList:resultIPs];
                
                NSLog(@">>>从固定域名获取ip列表线程执行完毕 ips: %@",resultIPs);
                if (resultIPs != nil) {
                    if (complete) {
                        complete(resultIPs);
                    }
                }
                
                dispatch_semaphore_signal(sema);
            } failed:^{
                weakSelf.progress += 0.05;
                NSLog(@"从%@未获取到ip，继续下一次获取...",domain);
                doNext = YES;//未获取到ip 需要继续执行其他的线程
                failedTimes ++;
                if (failedTimes == domains.count) {
                    if (failed) {
                        failed();
                    }
                }
                dispatch_semaphore_signal(sema);
            }];
        });
    }
}

/**
 从固定的域名获取ip列表
 
 @param domain 固定的域名 正式环境有三个备份域名
 */
- (void)fetchIPListFrom:(NSString *)domain host:(NSString *)host complete:(GBFetchIPListComplete)complete failed:(GBFetchIPListFailed)failed
{
    [self.serviceRequest startReqDomainListWithIP:domain Host:host];
    self.serviceRequest.successBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, id data) {
        if (type == ServiceRequestTypeDomainList) {
            if (data != nil) {
                if (complete) {
                    complete(data);
                }
            }
            else
            {
                if (failed) {
                    failed();
                }
            }
        }
    };
    self.serviceRequest.failBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, NSError *error) {
        if (type == ServiceRequestTypeDomainList) {
            if (failed) {
                failed();
            }
        }
    };
}

/**
 【串行】check相应的ip
 
 @param ips IP地址列表
 @param complete check完成回调 有一种类型check成功 则认定check成功
 @param failed check失败回调 当4种类型均check失败则认定为失败
 */

- (void)checkIP:(NSArray *)ips complete:(GBCheckIPFullTypeComplete)complete failed:(GBCheckIPFullTypeFailed)failed
{
    NSArray *checkTypes = @[@"https+8989",@"http+8787",@"https",@"http"];
    
    __weak typeof(self) weakSelf = self;
    
    //是否需要check下一个类型
    //当前check失败时需要check下一个类型
    __block BOOL doNext = YES;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("gb_checkIP_with_type_queue", NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    
    for (NSString *ip in ips) {
        for (int i = 0; i < checkTypes.count; i++) {
            NSString *checkType = checkTypes[i];
            
            dispatch_group_async(group, queue, ^{
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                if (doNext != YES) {
                    //先检测是否需要继续执行 不需要执行则直接跳过本线程
                    dispatch_semaphore_signal(sema);
                    return ;
                }
                NSLog(@">>>start check ip:%@ type:%@",ip,checkType);
                [weakSelf checkIP:ip checkType:checkType complete:^(NSString *type) {
                    NSLog(@"ip:%@check成功 type:%@", ip, type);
                    doNext = NO;//已经获取到ip 不需要继续执行其他的线程
                    dispatch_semaphore_signal(sema);
                    NSLog(@">>>ip:%@check完毕",ip);
                    if (complete) {
                        complete(ip, type);
                    }
                } failed:^{
                    self.progress += 0.05;
                    
                    NSLog(@"ip:%@check失败 type:%@ 继续【串行】check下一类型...", ip, checkType);
                    NSLog(@"%i",i);
                    doNext = YES;//未获取到ip 需要继续执行其他的线程
                    dispatch_semaphore_signal(sema);
                    if (i == (checkTypes.count-1)) {
                        //检测到最后一次依然失败 则判断失败
                        NSLog(@"ip:%@全部类型检测都失败",ip);
                        if (failed) {
                            failed();
                        }
                    }
                }];
            });
        }
    }
}

- (void)checkIP:(NSString *)ip checkType:(NSString *)checkType complete:(GBCheckIPComplete)complete failed:(GBCheckIPFailed)failed
{
    __weak typeof(self) weakSelf = self;
    [self.serviceRequest startCheckDomain:ip WithCheckType:checkType];
    self.serviceRequest.successBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, id data) {
        if (type == ServiceRequestTypeDomainCheck) {
            if (complete) {
                complete(checkType);
            }
        }
    };
    self.serviceRequest.failBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, NSError *error) {
        NSArray *checkTypeComponents = [checkType componentsSeparatedByString:@"+"];
        NSString *checkDomian = [NSString stringWithFormat:@"%@://%@%@",checkTypeComponents[0],ip,checkTypeComponents.count == 1 ? @"" : [NSString stringWithFormat:@":%@",checkTypeComponents[1]]];
        //记录错误日志
        [weakSelf.ipCheckErrorList addObject:@{RH_SP_COLLECTAPPERROR_DOMAIN:checkDomian,RH_SP_COLLECTAPPERROR_CODE:@"0",RH_SP_COLLECTAPPERROR_ERRORMESSAGE:error.description}];
        
        if (type == ServiceRequestTypeDomainCheck) {
            if (failed) {
                failed();
            }
        }
    };
}

- (void)checkAllIP:(NSArray *)ipList complete:(GBCheckAllIPsComplete)complete failed:(GBCheckAllIPsFailed)failed
{
    __weak typeof(self) weakSelf = self;
    __block int failedTimes = 0;
    
    //ip打乱再check
    ipList = [ipList sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    
    [self checkIP:ipList complete:^(NSString *ip, NSString *type) {
        //有某个类型check完毕
        weakSelf.progress += 0.2;
        
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        appDelegate.checkType = type;
        
        NSArray *checkTypeComponents = [type componentsSeparatedByString:@"+"];
        [appDelegate updateDomain:[NSString stringWithFormat:@"%@://%@%@",checkTypeComponents[0],ip,checkTypeComponents.count == 1 ? @"" : [NSString stringWithFormat:@":%@",checkTypeComponents[1]]]] ;
        
        if (complete) {
            complete();
        }
    } failed:^{
        //某条ip全部类型check失败
        //失败次数累加
        
        failedTimes ++;
        if (failedTimes == ipList.count) {
            //所有的ip及所有类型检测失败
            //清空缓存
            weakSelf.progress = 0;
            [[IPsCacheManager sharedManager] clearCaches];
            [weakSelf uploadLineCheckErr];
            if (failed) {
                failed();
            }
        }
    }];
}

- (void)startPageComplete
{
    [NSTimer scheduledTimerWithTimeInterval:5*60 target:self selector:@selector(refreshLineCheck) userInfo:nil repeats:YES];
    self.progressNote = @"检查完成,即将进入";
    self.progress = 1.0;
    
    __weak typeof(self) weakSelf = self;
    [self fetchAdInfo:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ifRespondsSelector(weakSelf.delegate, @selector(startPageViewControllerShowMainPage:))
            {
                [weakSelf.delegate startPageViewControllerShowMainPage:self];
                [self checkH5Ip];
                
            
            }
        });
    }];

}
//这里主要是广告业加载完成后检测用来供给LT的Ip
-(void)checkH5Ip{
    //
    __weak typeof(self) weakSelf = self;
    [self.serviceRequest fetchH5ip];
    self.serviceRequest.successBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, id data) {
        if (type == ServiceRequestTypeFetchH5Ip) {
            NSDictionary *dic = ConvertToClassPointer(NSDictionary, data);
            if (dic == nil) {
                dic = @{@"data":@""};
            } else {
                NSArray *ips = dic[@"data"];
                NSLog(@"ips====%@",ips);
                dispatch_group_t group = dispatch_group_create();
                dispatch_queue_t queue = dispatch_queue_create("checkIP_with_type_queue", NULL);
                __block NSInteger failTimes = 0;//计算失败次数
                
                for (NSString *ip in ips) {
                    dispatch_group_async(group, queue, ^{
                        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                        [weakSelf checkIP:ip checkType:@"https" complete:^(NSString *type) {
                            NSLog(@"chengong == %@",ip);
                            dispatch_semaphore_signal(semaphore);
                            RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
                            [appDelegate updateDomainName:ip];
                        } failed:^{
                            NSLog(@"shibai");
                            failTimes++;
                            dispatch_semaphore_signal(semaphore);
                            
                        }];
                        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                    });
                }
                dispatch_group_notify(group, queue, ^{
                    //当全部失败的时候重新请求
                    if (failTimes == ips.count) {
                        //全部没通过
                        [weakSelf checkH5Ip];
                    }
                });
            }
        }
    };
    weakSelf.serviceRequest.failBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, NSError *error) {
        [weakSelf.serviceRequest fetchH5ip];
    };
}

- (void)showErrAlertWithErrCode:(NSString *)code otherInfo:(NSDictionary *)otherInfo
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *ip = [self localIPAddress];
    NSString *title;
    NSString *msg ;
    if ([code isEqualToString:@"001"]) {
        title = @"网络连接失败";
        msg = [NSString stringWithFormat:@"\n网络连接失败，请确认您的网络连接正常后再次尝试！"];
    } else if ([code isEqualToString:@"002"]) {
        title = @"线路获取失败";
        msg = [NSString stringWithFormat:@"\n线路获取失败，请确认您的网络连接正常后再次尝试！"];
    } else if ([code isEqualToString:@"003"]) {
        title = @"服务器连接失败";
        msg = [NSString stringWithFormat:@"\n出现未知错误，请联系在线客服并提供以下信息。\n当前ip:%@\n版本号:%@", ip, [NSString stringWithFormat:@"iOS %@.%@",appVersion,RH_APP_VERCODE]];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:msg];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [messageText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msg.length)];
    [alert setValue:messageText forKey:@"attributedMessage"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//获取设备IP地址
- (NSString *)localIPAddress
{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return dict[@"cip"] ? dict[@"cip"] : @"";
    }
    return @"";
}

- (void)uploadLineCheckErr
{
    NSMutableDictionary *dictError = [[NSMutableDictionary alloc] init] ;
    [dictError setValue:SID forKey:RH_SP_COLLECTAPPERROR_SITEID] ;
    [dictError setValue:[self randomMark] forKey:RH_SP_COLLECTAPPERROR_MARK] ;
    [dictError setValue:[self localIPAddress]?[self localIPAddress]:@"" forKey:RH_SP_COLLECTAPPERROR_IP] ;
    if ([RH_UserInfoManager shareUserManager].loginUserName.length){
        [dictError setValue:[RH_UserInfoManager shareUserManager].loginUserName
                     forKey:RH_SP_COLLECTAPPERROR_USERNAME] ;
        [dictError setValue:[RH_UserInfoManager shareUserManager].loginTime
                     forKey:RH_SP_COLLECTAPPERROR_LASTLOGINTIME] ;
    }
    NSMutableString *domainList = [[NSMutableString alloc] init] ;
    NSMutableString *errorCodeList = [[NSMutableString alloc] init] ;
    NSMutableString *errorMessageList = [[NSMutableString alloc] init] ;
    for (NSDictionary *dictTmp in self.ipCheckErrorList) {
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
    [dictError setValue:@"1" forKey:RH_SP_COLLECTAPPERROR_TYPE];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    [dictError setValue:appVersion forKey:RH_SP_COLLECTAPPERROR_VERSIONNAME];
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    [dictError setValue:sysVersion forKey:RH_SP_COLLECTAPPERROR_SYSCODE];
    [dictError setValue:@"iOS" forKey:RH_SP_COLLECTAPPERROR_CHANNEL];
    NSString *deviceBrands = [[UIDevice currentDevice] model];
    [dictError setValue:deviceBrands forKey:RH_SP_COLLECTAPPERROR_BRANDS];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    [dictError setValue:deviceModel forKey:RH_SP_COLLECTAPPERROR_MODEL];
    
    [self.serviceRequest startUploadAPPErrorMessge:dictError] ;
    self.serviceRequest.successBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, id data) {
        //
    };
    self.serviceRequest.failBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, NSError *error) {
        //
    };
}

- (NSString *)randomMark
{
    static int kNumber = 6;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (void)refreshLineCheck
{
    __weak typeof(self) weakSelf = self;
    //测试环境使用配置的固定域名
    //不需要去DNS获取动态bossapi
    if (IS_DEV_SERVER_ENV) {
        NSMutableArray *hostUrlArr = [NSMutableArray arrayWithArray:RH_API_MAIN_URL] ;
        //从动态域名列表依次尝试获取ip列表
        [self fetchIPs:hostUrlArr host:@"" complete:^(NSDictionary *ips) {
            
            //从某个固定域名列表获取到了ip列表
            //根据优先级并发check
            /**
             * 优先级
             * 1 https+8989
             * 2 http+8787
             * 3 https
             * 4 http
             */
            NSString *resultDomain = [ips objectForKey:@"domain"];
            RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
            [appDelegate updateHeaderDomain:resultDomain];
            
            NSArray *ipList = [ips objectForKey:@"ips"];
            
            //多ip地址【异步并发】check 但check的优先级是【串行】的
            //使用NSOperationQueue 方便取消后续执行
            
            //check iplist
            [weakSelf checkAllIP:ipList complete:^{
                //check完成
            } failed:^{
            }];
        } failed:^{
        }];
    }
    else
    {
        NSDictionary *host = [[IPsCacheManager sharedManager] bossApis];
        if (host) {
            NSString *hostName = [host objectForKey:@"host"];
            
            //将此数据随机打乱 减轻服务器压力
            NSArray *hostips = [host objectForKey:@"ips"];
            hostips = [hostips sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
                int seed = arc4random_uniform(2);
                if (seed) {
                    return [str1 compare:str2];
                } else {
                    return [str2 compare:str1];
                }
            }];
            
            NSMutableArray *hostUrlArr = [NSMutableArray array];
            for (NSString *hostip in hostips) {
                NSString *hostUrl = [NSString stringWithFormat:@"https://%@:1344/boss-api",hostip];
                [hostUrlArr addObject:hostUrl];
            }
            
            //从动态域名列表依次尝试获取ip列表
            [weakSelf fetchIPs:hostUrlArr host:hostName complete:^(NSDictionary *ips) {
                
                //从某个固定域名列表获取到了ip列表
                //根据优先级并发check
                /**
                 * 优先级
                 * 1 https+8989
                 * 2 http+8787
                 * 3 https
                 * 4 http
                 */
                NSString *resultDomain = [ips objectForKey:@"domain"];
                RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
                [appDelegate updateHeaderDomain:resultDomain];
                
                NSArray *ipList = [ips objectForKey:@"ips"];
                
                //多ip地址【异步并发】check 但check的优先级是【串行】的
                //使用NSOperationQueue 方便取消后续执行
                
                //check iplist
                [weakSelf checkAllIP:ipList complete:^{
                    //check完成
                } failed:^{
                }];
            } failed:^{
                //从所有的固定域名列表没有获取到ip列表
            }];
        }
    }
}

- (void)fetchAdInfo:(GBShowAdComplete)complete
{
    __weak typeof(self) weakSelf = self;
    
    [self.serviceRequest startV3InitAd];
    self.serviceRequest.successBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, id data) {
        if (type == ServiceRequestTypeV3INITAD) {
            RH_InitAdModel *adModel =ConvertToClassPointer(RH_InitAdModel, data);
            if (adModel && adModel.mInitAppAd != nil && ![adModel.mInitAppAd isEqualToString:@""]) {
                //有广告则显示广告
                weakSelf.adView.adImageUrl = [NSString stringWithFormat:@"%@%@",weakSelf.appDelegate.domain,adModel.mInitAppAd];
                [weakSelf.adView show:^{
                    //广告显示完成 进入主页面
                    if (complete) {
                        complete();
                    }
                }];
            }
            else
            {
                //无广告 则直接进入首页
                if (complete) {
                    complete();
                }
            }
        }
    };
    self.serviceRequest.failBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, NSError *error) {
        //广告获取失败 进入主页面
        if (complete) {
            complete();
        }
    };
}

@end

