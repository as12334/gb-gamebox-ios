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

@interface StartPageViewController ()

@property (nonatomic, strong) NSString *progressNote;
@property (nonatomic, assign) CGFloat progress;

@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UILabel *cRightsLB;
@property (weak, nonatomic) IBOutlet UILabel *versionLB;
@property (weak, nonatomic) IBOutlet UILabel *progressNoteLB;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) UIButton *doitAgainBT;
@property (strong, nonatomic) NSString *checkedIP;

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
    [self doRequest];
}

#pragma mark - Private M

- (void)setupUI
{
    self.hiddenStatusBar = YES;
    self.hiddenNavigationBar = YES;

    /**
     * 119 270 特殊处理
     */
    [self.launchImageView setImage:ImageWithName(@"startImage")];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [self.cRightsLB setText:[NSString stringWithFormat:@"Copyrihgt © %@ Reserved.",app_Name]];
    [self.versionLB setText:[NSString stringWithFormat:@"v%@",app_Version]];
    
    self.doitAgainBT.layer.cornerRadius = 10.0;
    self.doitAgainBT.clipsToBounds = YES;
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
    self.progressView.progress = _progress;
    if (_progress == 0) {
        self.progressNote = @"";
    }
}

- (UIButton *)doitAgainBT
{
    if (_doitAgainBT == nil) {
        _doitAgainBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _doitAgainBT.backgroundColor = [UIColor yellowColor];
        [_doitAgainBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_doitAgainBT setTitle:@"重新匹配" forState:UIControlStateNormal];        [_doitAgainBT setTitleColor:colorWithRGB(0, 122, 255) forState:UIControlStateNormal];
        _doitAgainBT.frame = CGRectMake(0, 0, 100, 33);
        _doitAgainBT.titleLabel.font = [UIFont systemFontOfSize:15];
        _doitAgainBT.hidden = YES;
        [self.view addSubview:_doitAgainBT];
        [self.view bringSubviewToFront:_doitAgainBT];

        _doitAgainBT.center = self.progressView.center;
        [_doitAgainBT addTarget:self action:@selector(doItAgainAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doitAgainBT;
}

//先从三个固定的链接获取动态ip地址
//该动态ip地址用于获取check ip列表
//以此减轻服务端压力

- (void)fetchHost:(GBFetchHostComplete)complete failed:(GBFetchHostFailed)failed
{
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
                        }
                        else
                        {
                            NSLog(@"从%@未获取到Host，继续下一次获取...",host);
                            doNext = YES;
                            failTimes++;
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

    NSLog(@"");
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
            [weakSelf shoudShowUpdateAlert];
        }];
        return;
    }
    
    //先从获取动态HOST
    [self fetchHost:^(NSDictionary *host) {
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
        
        //测试环境使用配置的固定域名
        if (IS_DEV_SERVER_ENV) {
            hostUrlArr = [NSMutableArray arrayWithArray:RH_API_MAIN_URL] ;
        }
        
        self.progressNote = @"正在检查线路,请稍候";
        
        //从动态域名列表依次尝试获取ip列表
        [self fetchIPs:hostUrlArr host:hostName complete:^(NSDictionary *ips) {
            self.progress = 0.3;
            
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
            self.progressNote = @"正在匹配服务器...";
            [self checkAllIP:ipList complete:^{
                [weakSelf shoudShowUpdateAlert];
            }];
        } failed:^{
            //从所有的固定域名列表没有获取到ip列表
            weakSelf.progress = 0;
        }];
    } failed:^{
        weakSelf.progress = 0;
    }];
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
//                ips = @{@"domain":@"6614777.com",@"ips":@[@"1.1.1.1",@"14.215.171.197",@"2.2.2.2",@"3.3.3.3"]};
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
                self.progress += 0.05;
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
    [self.serviceRequest startCheckDomain:ip WithCheckType:checkType];
    self.serviceRequest.successBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, id data) {
        if (type == ServiceRequestTypeDomainCheck) {
            if (complete) {
                complete(checkType);
            }
        }
    };
    self.serviceRequest.failBlock = ^(RH_ServiceRequest *serviceRequest, ServiceRequestType type, NSError *error) {
        if (type == ServiceRequestTypeDomainCheck) {
            if (failed) {
                failed();
            }
        }
    };
}

- (void)checkAllIP:(NSArray *)ipList complete:(GBCheckAllIPsComplete)complete
{
    __weak typeof(self) weakSelf = self;
    __block int failedTimes = 0;
    
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
        }
    }];
}

- (void)shoudShowUpdateAlert
{
    __weak typeof(self) weakSelf = self;
    //检测更新
    BOOL isUpdateStatusValid = [[UpdateStatusCacheManager sharedManager] isUpdateStatusValid];
    if (isUpdateStatusValid) {
        //依然有效 则直接进入游戏
        [self startPageComplete];
    }
    else
    {
        [[UpdateStatusCacheManager sharedManager] showUpdateAlert:^{
            //不是强制更新 且 点击了跳过更新按钮
            [weakSelf startPageComplete];
        }];
    }
}

- (void)startPageComplete
{
    self.progressNote = @"检查完成,即将进入";
    self.progress = 1.0;
    
    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ifRespondsSelector(weakSelf.delegate, @selector(startPageViewControllerShowMainPage:))
        {
            [weakSelf.delegate startPageViewControllerShowMainPage:self];
        }
    });
}

@end
