//
//  RH_ServiceRequest.m
//  CoreLib
//
//  Created by jinguihua on 2016/11/30.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "RH_ServiceRequest.h"
#import "RH_HTTPRequest.h"
#import "NSError+RH_HTTPRequest.h"
#import "RH_ErrorCode.h"
#import "RH_API.h"
#import "coreLib.h"
#import "RH_UpdatedVersionModel.h"
#import "RH_APPDelegate.h"
#import "RH_UserInfoManager.h"
///-------DATA MODULE--------------------//
#import "RH_HomePageModel.h"
#import "RH_BettingInfoModel.h"
#import "RH_OpenActivityModel.h"
#import "RH_BettingDetailModel.h"
#import "RH_CapitalInfoOverviewModel.h"
#import "RH_CapitalDetailModel.h"
#import "RH_CapitalTypeModel.h"
#import "RH_BankCardModel.h"
#import "RH_PromoInfoModel.h"
#import "RH_SystemNoticeModel.h"
#import "RH_SystemNoticeDetailModel.h"
#import "RH_UserGroupInfoModel.h"
#import "RH_GameNoticeModel.h"
#import "RH_GameNoticeDetailModel.h"
#import "RH_BitCodeModel.h"
#import "RH_SiteMessageModel.h"
#import "RH_SiteMyMessageModel.h"
#import "RH_DiscountActivityTypeModel.h"
#import "RH_DiscountActivityModel.h"
#import "RH_SendMessageVerityModel.h"
#import "RH_SiteMyMessageDetailModel.h"
#import "RH_WithDrawModel.h"
#import "RH_SiteMsgSysMsgModel.h"
#import "RH_ActivityStatusModel.h"
#import "RH_SiteMsgUnReadCountModel.h"
#import "RH_SharePlayerRecommendModel.h"
#import "RH_RegisetInitModel.h"
#import "RH_DepositeTransferModel.h"
#import "RH_DepositePayAccountModel.h"
#import "RH_AboutUsModel.h" // 关于我们
#import "RH_RegisterClauseModel.h" //注册条款
#import "RH_HelpCenterModel.h" //帮助中心
#import "RH_HelpCenterSecondModel.h" //帮助中心二级界面
#import "RH_HelpCenterDetailModel.h"
#import "RH_GetNoAutoTransferInfoModel.h"
#import "RH_DepositOriginseachSaleModel.h"
#import "RH_UserApiBalanceModel.h"
#import "RH_DepositeTransferChannelModel.h"
#import "RH_ShareRecordModel.h"
#import "RH_InitAdModel.h"
#import "No_AccessView.h"
#import "CheckTimeManager.h"
//----------------------------------------------------------
//访问权限
typedef NS_ENUM(NSInteger,ServiceScopeType) {
    //公开
    ServiceScopeTypePublic,
};

#define userInfo_manager   [RH_UserInfoManager shareUserManager]
//----------------------------------------------------------

//请求上下文
@interface RH_ServiceRequestContext : NSObject

- (id)initWithSerivceType:(ServiceRequestType)serivceType
                scopeType:(ServiceScopeType)scopeType;

//访问权限
@property(nonatomic,readonly) ServiceScopeType scopeType;

//服务类型
@property(nonatomic,readonly) ServiceRequestType serivceType;

@end

//----------------------------------------------------------


@implementation RH_ServiceRequestContext

- (id)initWithSerivceType:(ServiceRequestType)serivceType scopeType:(ServiceScopeType)scopeType
{
    self = [super init];

    if (self) {
        _serivceType = serivceType;
        _scopeType = scopeType;
    }

    return self;
}
@end

//------------------------------------------------------------------
@interface RH_ServiceRequest ()<RH_HTTPRequestDelegate>
@property(nonatomic,strong,readonly) NSMutableDictionary * httpRequests;

@property(nonatomic,strong,readonly) NSMutableDictionary * requestingMarks;
@property(nonatomic,strong,readonly) NSString * uniqueID;

//上下文
@property(nonatomic,strong,readonly) NSMutableDictionary * contexts;
@property(nonatomic,strong,readonly) NSMutableDictionary * doSometiongMasks;

//
@property (nonatomic,strong,readonly) RH_APPDelegate *appDelegate ;
@end

//------------------------------------------------------------------

@implementation RH_ServiceRequest
@synthesize httpRequests = _httpRequests;
@synthesize requestingMarks = _requestingMarks;
@synthesize uniqueID = _uniqueID;
@synthesize contexts = _contexts;
@synthesize doSometiongMasks = _doSometiongMasks;
@synthesize appDelegate = _appDelegate ;


-(RH_APPDelegate *)appDelegate
{
    if (!_appDelegate){
        _appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
    }
    
    return _appDelegate ;
}

#pragma mark-用户接口定义
-(void)startReqDomainListWithIP:(NSString*)ip Host:(NSString *)host
{
    NSDictionary *headerArg = (host == nil || [host isEqualToString:@""]) ? @{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE]} : @{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE], @"Host":host};
    
    [self _startServiceWithAPIName:ip
                        pathFormat:RH_API_NAME_BOSSSYSDOMAIN
                     pathArguments:nil
                   headerArguments:headerArg
                    queryArguments:@{RH_SP_COMMON_SITECODE:CODE,
                                     RH_SP_COMMON_SITESEC:S,
                                     RH_SP_COMMON_OSTYPE:@"ips",
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeDomainList
                         scopeType:ServiceScopeTypePublic];
}

-(void)startReqDomainListWithDomain:(NSString*)domain
{
    [self _startServiceWithAPIName:domain
                        pathFormat:RH_API_NAME_BOSSSYSDOMAIN
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE]}
                    queryArguments:@{RH_SP_COMMON_SITECODE:CODE,
                                     RH_SP_COMMON_SITESEC:S,
                                     RH_SP_COMMON_OSTYPE:@"ips",
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeDomainList
                         scopeType:ServiceScopeTypePublic];
}

-(void)startCheckDomain:(NSString*)doMain WithCheckType:(NSString *)checkType
{
    NSString *urlStr;
    if ([checkType isEqualToString:@"https"]) {
        urlStr = @"https://%@/__check";
    }
    else if ([checkType isEqualToString:@"http"]){
        urlStr = @"http://%@/__check";
    }
    else if ([checkType isEqualToString:@"https+8989"]){
        urlStr = @"https://%@:8989/__check";
    }
    else if ([checkType isEqualToString:@"http+8787"]){
        urlStr = @"http://%@:8787/__check";
    }
        [self _startServiceWithAPIName:nil
                            pathFormat:urlStr
                         pathArguments:@[doMain?:@""]
                       headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Host":self.appDelegate.headerDomain
                                         }
                        queryArguments:nil
                         bodyArguments:nil
                              httpType:HTTPRequestTypeGet
                           serviceType:ServiceRequestTypeDomainCheck
                             scopeType:ServiceScopeTypePublic];
}

-(void)startUpdateCheck
{
    [self _startServiceWithAPIName:self.appDelegate.apiDomain
                        pathFormat:@"app/update.html"
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{RH_SP_COMMON_OSTYPE:@"ios",
                                     RH_SP_COMMON_CHECKVERSION:RH_APP_UPDATECHECK
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeUpdateCheck
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark ==============updateCheck================
-(void)startV3UpdateCheck
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:@"mobile-api/app/update.html"
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{@"code":S,
                                     @"type":@"ios",
                                     @"siteId":SID
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3UpdateCheck
                         scopeType:ServiceScopeTypePublic];
}

-(void)startLoginWithUserName:(NSString*)userName Password:(NSString*)password VerifyCode:(NSString*)verCode
{
    
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
        [self _startServiceWithAPIName:self.appDelegate.domain
                            pathFormat:RH_API_NAME_LOGIN
                         pathArguments:nil
                       headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                         @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Cookie":userInfo_manager.sidString?:@"",
                                         @"Host":self.appDelegate.headerDomain
                                         }
                        queryArguments:verCode.length?@{@"username":userName?:@"",
                                                        @"password":password?:@"",
                                                        @"captcha":verCode
                                                        } :@{@"username":userName?:@"",
                                                             @"password":password?:@""
                                                             }
                         bodyArguments:nil
                              httpType:HTTPRequestTypePost
                           serviceType:ServiceRequestTypeUserLogin
                             scopeType:ServiceScopeTypePublic];
    }else
    {
        [self _startServiceWithAPIName:self.appDelegate.domain
                            pathFormat:RH_API_NAME_LOGIN
                         pathArguments:nil
                       headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                         @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Host":self.appDelegate.headerDomain
                                         }
                        queryArguments:verCode.length?@{@"username":userName?:@"",
                                                        @"password":password?:@"",
                                                        @"captcha":verCode
                                                        } :@{@"username":userName?:@"",
                                                             @"password":password?:@""
                                                             }
                         bodyArguments:nil
                              httpType:HTTPRequestTypePost
                           serviceType:ServiceRequestTypeUserLogin
                             scopeType:ServiceScopeTypePublic];
    }
}

-(void)startAutoLoginWithUserName:(NSString*)userName Password:(NSString*)password
{
   
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
        [self _startServiceWithAPIName:self.appDelegate.domain
                            pathFormat:RH_API_NAME_AUTOLOGIN
                         pathArguments:nil
                       headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                         @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Cookie":userInfo_manager.sidString?:@"",
                                         @"Host":self.appDelegate.headerDomain
                                         }
                        queryArguments:@{@"username":userName?:@"",
                                         @"password":password?:@""
                                         }
                         bodyArguments:nil
                              httpType:HTTPRequestTypePost
                           serviceType:ServiceRequestTypeUserAutoLogin
                             scopeType:ServiceScopeTypePublic];
    }else
    {
        [self _startServiceWithAPIName:self.appDelegate.domain
                            pathFormat:RH_API_NAME_AUTOLOGIN
                         pathArguments:nil
                       headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                         @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Host":self.appDelegate.headerDomain
                                         }
                        queryArguments:@{@"username":userName?:@"",
                                         @"password":password?:@""
                                         }
                         bodyArguments:nil
                              httpType:HTTPRequestTypePost
                           serviceType:ServiceRequestTypeUserAutoLogin
                             scopeType:ServiceScopeTypePublic];
    }
    
}

-(void)startGetVerifyCode
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;
        NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
        [self _startServiceWithAPIName:self.appDelegate.domain
                            pathFormat:RH_API_NAME_VERIFYCODE
                         pathArguments:nil
                       headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                         @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Cookie":userInfo_manager.sidString?:@"",
                                         @"Host":self.appDelegate.headerDomain
                                         }
                        queryArguments:@{@"_t":timeStr}
                         bodyArguments:nil
                              httpType:HTTPRequestTypePost
                           serviceType:ServiceRequestTypeObtainVerifyCode
                             scopeType:ServiceScopeTypePublic];
    }else
    {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;
        NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
        [self _startServiceWithAPIName:self.appDelegate.domain
                            pathFormat:RH_API_NAME_VERIFYCODE
                         pathArguments:nil
                       headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                         @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Host":self.appDelegate.headerDomain
                                         }
                        queryArguments:@{@"_t":timeStr}
                         bodyArguments:nil
                              httpType:HTTPRequestTypePost
                           serviceType:ServiceRequestTypeObtainVerifyCode
                             scopeType:ServiceScopeTypePublic];
    }
    
}

-(void)startGetSecurePasswordVerifyCode {
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;
        NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
        [self _startServiceWithAPIName:self.appDelegate.domain
                            pathFormat:RH_API_NAME_VERIFYCODE
                         pathArguments:nil
                       headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                         @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Cookie":userInfo_manager.sidString?:@"",
                                         @"Host":self.appDelegate.headerDomain,
                                         }
                        queryArguments:@{@"_t":timeStr}
                         bodyArguments:nil
                              httpType:HTTPRequestTypePost
                           serviceType:ServiceRequestTypeV3SafetyObtainVerifyCode
                             scopeType:ServiceScopeTypePublic];
    }else
    {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;
        NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
        [self _startServiceWithAPIName:self.appDelegate.domain
                            pathFormat:RH_API_NAME_VERIFYCODE
                         pathArguments:nil
                       headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                         @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Host":self.appDelegate.headerDomain,
                                         }
                        queryArguments:@{@"_t":timeStr}
                         bodyArguments:nil
                              httpType:HTTPRequestTypePost
                           serviceType:ServiceRequestTypeV3SafetyObtainVerifyCode
                             scopeType:ServiceScopeTypePublic];
    }
    
}

-(void)startDemoLogin
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
        [self _startServiceWithAPIName:self.appDelegate.domain
                            pathFormat:RH_API_NAME_DEMOLOGIN
                         pathArguments:nil
                       headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                         @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Host":self.appDelegate.headerDomain,
                                         @"Cookie":userInfo_manager.sidString?:@""
                                         }
                        queryArguments:nil
                         bodyArguments:nil
                              httpType:HTTPRequestTypePost
                           serviceType:ServiceRequestTypeDemoLogin
                             scopeType:ServiceScopeTypePublic];
    }else
    {
        [self _startServiceWithAPIName:self.appDelegate.domain
                            pathFormat:RH_API_NAME_DEMOLOGIN
                         pathArguments:nil
                       headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                         @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Host":self.appDelegate.headerDomain
                                         }
                        queryArguments:nil
                         bodyArguments:nil
                              httpType:HTTPRequestTypePost
                           serviceType:ServiceRequestTypeDemoLogin
                             scopeType:ServiceScopeTypePublic];
    }
}

-(void)startGetCustomService
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_GETCUSTOMPATH
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeGetCustomService
                         scopeType:ServiceScopeTypePublic];
}

-(void)startAPIRetrive:(NSInteger)apiID
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_APIRETRIVE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{RH_SP_APIRETRIVE_APIID:@(apiID)}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeAPIRetrive
                         scopeType:ServiceScopeTypePublic];
}

-(void)startUploadAPPErrorMessge:(NSDictionary*)errorDict
{
    [self _startServiceWithAPIName:@"https://apiplay.info:1344/boss-api"
                        pathFormat:RH_API_NAME_COLLECTAPPERROR
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
//                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:errorDict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeCollectAPPError
                         scopeType:ServiceScopeTypePublic];
}

-(void)startTestUrl:(NSString*)testURL
{
    [self _startServiceWithAPIName:testURL
                        pathFormat:nil
                     pathArguments:nil
                   headerArguments:nil
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeTestUrl
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - v3 接口定义
-(void)startV3HomeInfo
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_HOMEINFO
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain,
                                     @"Cookie":userInfo_manager.sidString?:@""
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3HomeInfo
                         scopeType:ServiceScopeTypePublic];
}

-(void)startV3UserInfo
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_USERINFO
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3UserInfo
                         scopeType:ServiceScopeTypePublic];
}

-(void)startV3MineLinkInfo
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_MINEGROUPINFO
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3MineGroupInfo
                         scopeType:ServiceScopeTypePublic];
}

-(void)startV3ActivityStaus:(NSString*)activityID
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ACTIVITYSTATUS
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{RH_SP_ACTIVITYSTATUS_MESSAGEID:activityID?:@""}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3ActivityStatus
                         scopeType:ServiceScopeTypePublic];
}
-(void)startV3GameListWithApiID:(NSInteger)apiID
                      ApiTypeID:(NSInteger)apiTypeID
                     PageNumber:(NSInteger)pageNumber
                       PageSize:(NSInteger)pageSize
                     SearchName:(NSString*)searchName
                          TagID:(NSString*)tagID;
{
    NSMutableDictionary *dictTmp = [[NSMutableDictionary alloc] init] ;
    [dictTmp setValue:@(apiID) forKey:RH_SP_APIGAMELIST_APIID] ;
    [dictTmp setValue:@(apiTypeID) forKey:RH_SP_APIGAMELIST_APITYPEID] ;
    [dictTmp setValue:@(pageNumber) forKey:RH_SP_APIGAMELIST_PAGENUMBER] ;
    [dictTmp setValue:@(pageSize) forKey:RH_SP_APIGAMELIST_PAGESIZE] ;
    if (searchName.length){
        [dictTmp setValue:searchName forKey:RH_SP_APIGAMELIST_NAME] ;
    }
    if (tagID.length){
        if ([tagID isEqualToString:@"all"]) {
            [dictTmp setValue:@"" forKey:RH_SP_APIGAMELIST_TAGID] ;
        }else
        {
            [dictTmp setValue:tagID forKey:RH_SP_APIGAMELIST_TAGID] ;
        }
    }
    
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_APIGAMELIST
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dictTmp
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3APIGameList
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark -投注列表
-(void)startV3BettingList:(NSString*)startDate EndDate:(NSString*)endDate
               PageNumber:(NSInteger)pageNumber
                 PageSize:(NSInteger)pageSize withIsStatistics:(BOOL)isShowStatistics
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_BETTINGLIST
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                      @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{RH_SP_BETTINGLIST_STARTDATE:startDate?:@"",
                                     RH_SP_BETTINGLIST_ENDDATE:endDate?:@"",
                                    RH_SP_BETTINGLIST_ISSHOWSTATISTICS:@(isShowStatistics),
                                     RH_SP_BETTINGLIST_PAGENUMBER:@(pageNumber),
                                     RH_SP_BETTINGLIST_PAGESIZE:@(pageSize)
                        
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3BettingList
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark -- 资金记录
-(void)startV3DepositList:(NSString*)startDate
                  EndDate:(NSString*)endDate
               SearchType:(NSString*)type
               PageNumber:(NSInteger)pageNumber
                 PageSize:(NSInteger)pageSize
{
    NSMutableDictionary *dictTmp = [[NSMutableDictionary alloc] init] ;
    [dictTmp setValue:startDate?:@"" forKey:RH_SP_DEPOSITLIST_STARTDATE] ;
    [dictTmp setValue:endDate?:@"" forKey:RH_SP_DEPOSITLIST_ENDDATE] ;
    [dictTmp setValue:@(pageNumber) forKey:RH_SP_DEPOSITLIST_PAGENUMBER] ;
    [dictTmp setValue:@(pageSize) forKey:RH_SP_DEPOSITLIST_PAGESIZE] ;
//    if (type.length){
//        [dictTmp setValue:startDate?:type forKey:RH_SP_DEPOSITLIST_TYPE] ;
//    }
    [dictTmp setValue:type forKey:RH_SP_DEPOSITLIST_TYPE] ;
    
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_DEPOSITLIST
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                      @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dictTmp
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3DepositList
                         scopeType:ServiceScopeTypePublic] ;
}

#pragma mark - 用户安全码初始化信息
- (void)startV3UserSafetyInfo
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_USERSAFEINFO
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                      @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3UserSafeInfo
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 设置真实名字
- (void)startV3SetRealName:(NSString *)name
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SETREALNAME
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                      @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{@"realName":name?:@""}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SetRealName
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 修改安全密码
- (void)startV3ModifySafePasswordWithRealName:(nullable NSString *)realName
                               originPassword:(nullable NSString *)originPwd
                                  newPassword:(nullable NSString *)pwd1
                              confirmPassword:(nullable NSString *)pwd2
                                   verifyCode:(nullable NSString *)code
{
    NSMutableDictionary *dictTmp = [[NSMutableDictionary alloc] init] ;
    [dictTmp setValue:realName?:@"" forKey:RH_SP_UPDATESAFEPASSWORD_REALNAME] ;
    [dictTmp setValue:originPwd?:@"" forKey:RH_SP_UPDATESAFEPASSWORD_ORIGINPWD] ;
    [dictTmp setValue:pwd1?:@"" forKey:RH_SP_UPDATESAFEPASSWORD_NEWPWD] ;
    [dictTmp setValue:pwd2?:@"" forKey:RH_SP_UPDATESAFEPASSWORD_CONFIRMPWD] ;
    if (code.length){
        [dictTmp setValue:code forKey:RH_SP_UPDATESAFEPASSWORD_VERIFYCODE] ;
    }
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_UPDATESAFEPASSWORD
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dictTmp
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3UpdateSafePassword
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 修改登录密码
- (void)startV3UpdateLoginPassword:(NSString *)password
                       newPassword:(NSString *)newPassword
                        verifyCode:(NSString *)code
{
    NSMutableDictionary *dictTmp = [[NSMutableDictionary alloc] init] ;
    [dictTmp setValue:password?:@"" forKey:RH_SP_MINEMODIFYPASSWORD_OLDPASSWORD] ;
    [dictTmp setValue:newPassword?:@"" forKey:RH_SP_MINEMODIFYPASSWORD_NEWPASSWORD] ;
    if (code.length){
        [dictTmp setValue:code forKey:RH_SP_MINEMODIFYPASSWORD_PASSWORDCODE] ;
    }
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_MINEMODIFYPASSWORD
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dictTmp
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3UpdateLoginPassword
                         scopeType:ServiceScopeTypePublic];
}


#pragma mark 拆红包
-(void)startV3OpenActivity:(NSString *)activityID andGBtoken:(NSString *)gbtoken
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:activityID forKey:RH_SP_OPENACTIVITY_MESSAGEID ];
    [dict setValue:gbtoken forKey:RH_SP_OPENACTIVITY_TOKEN];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_OPENACTIVITY
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3OpenActivity
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark 投注记录详情
-(void)startV3BettingDetails:(NSInteger)listId
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
    [dict setValue:@(listId) forKey:RH_SP_BETTINGDETAILS_LISTID] ;
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_BETTINGDETAILS
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3BettingDetails
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 资金记录详情 根据ID进行查询
-(void)startV3DepositListDetail:(NSString*)searchId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:searchId forKey:RH_SP_DEPOSITLISTDETAILS_SEARCHID];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_DEPOSITLISTDETAILS
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3DepositListDetails
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark 资金详情下拉列表
-(void)startV3DepositPulldownList
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_DEPOSITPULLDOWNLIST
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3DepositPullDownList
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 添加银行卡
-(void)startV3addBankCarkbankcardMasterName:(NSString *)bankcardMasterName
                                   bankName:(NSString *)bankName
                             bankcardNumber:(NSString *)bankcardNumber
                                bankDeposit:(NSString *)bankDeposit
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:bankcardMasterName forKey:RH_SP_BANKCARDMASTERNAME];
    [dict setValue:bankName forKey:RH_SP_BANKNAME];
    [dict setValue:bankcardNumber forKey:RH_SP_BANKCARDNUMBER];
    [dict setValue:bankDeposit forKey:RH_SP_BANKDEPOSIT];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ADDBANKCARD
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3AddBankCard
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 获取系统公告
-(void)startV3LoadSystemNoticeStartTime:(NSString *)startTime
                                endTime:(NSString *)endTime
                             pageNumber:(NSInteger)pageNumber
                               pageSize:(NSInteger)pageSize
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    if (startDate > endDate) {
        showAlertView(@"提示", @"时间选择有误,请重试选择");
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:startTime?:@"" forKey:RH_SP_SYSTEMNOTICE_STARTTIME];
    [dict setValue:endTime?:@"" forKey:RH_SP_SYSTEMNOTICE_ENDTIME];
    [dict setValue:@(pageNumber) forKey:RH_SP_SYSTEMNOTICE_PAGENUMBER];
    [dict setValue:@(pageSize) forKey:RH_SP_SYSTEMNOTICE_PAGESIZE];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SYSTEMNOTICE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SystemNotice
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 获取公告详情
-(void)startV3LoadSystemNoticeDetailSearchId:(NSString *)searchId{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:searchId forKey:RH_SP_SYSTEMNOTICEDETAIL_SEARCHID];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SYSTEMNOTICEDETAIL
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SystemNoticeDetail
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark -  游戏公告
-(void)startV3LoadGameNoticeStartTime:(NSString *)startTime
                              endTime:(NSString *)endTime
                           pageNumber:(NSInteger)pageNumber
                             pageSize:(NSInteger)pageSize
                                apiId:(NSInteger)apiId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:startTime?:@"" forKey:RH_SP_GAMENOTICE_STARTTIME];
    [dict setValue:endTime?:@"" forKey:RH_SP_GAMENOTICE_ENDTIME];
    [dict setValue:@(pageNumber) forKey:RH_SP_GAMENOTICE_PAGENUMBER];
    [dict setValue:@(pageSize) forKey:RH_SP_GAMENOTICE_PAGESIZE];
    if (apiId>0){
        [dict setValue:@(apiId) forKey:RH_SP_GAMENOTICE_APIID];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    if (startDate > endDate) {
        showAlertView(@"提示", @"时间选择有误,请重试选择");
    }
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_GAMENOTICE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3GameNotice
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark -  游戏公告详情
-(void)startV3LoadGameNoticeDetailSearchId:(NSString *)searchId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:searchId forKey:RH_SP_GAMENOTICEDETAIL_SEARCHID];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_GAMENOTICEDETAIL
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3GameNoticeDetail
                         scopeType:ServiceScopeTypePublic];
    
}
#pragma mark - 获取安全验证码
-(void)startV3GetSafetyVerifyCode
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SAFETYCAPCHA
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{@"_t":timeStr}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SafetyObtainVerifyCode
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark -优惠记录列表
-(void)startV3PromoList:(NSInteger)pageNumber
               PageSize:(NSInteger)pageSize
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_PROMOLIST
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{RH_SP_PROMOLIST_PAGENUMBER:@(pageNumber),
                                     RH_SP_PROMOLIST_PAGESIZE:@(pageSize)
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3PromoList
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark -  一键回收&单个回收
-(void)startV3OneStepRecoverySearchId:(NSString *)searchId
{
    NSLog(@"self.appDelegate.domain===%@",self.appDelegate.domain);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:searchId forKey:RH_SP_ONESTEPRECOVERY_SEARCHAPIID];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ONESTEPRECOVERY
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:dict?:@{}
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3OneStepRecory
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark - V3 添加/保存比特币
-(void)startV3AddBtcWithNumber:(NSString *)bitNumber
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ADDBTC
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{RH_SP_ADDBTC_BANKCARDNUMBER:(bitNumber?:@"")}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3AddBitCoin
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 站点信息 - 系统消息
-(void)startV3LoadSystemMessageWithpageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pageNumber) forKey:RH_SP_SITEMESSAGE_PAGINGPAGENUMBER];
    [dict setValue:@(pageSize) forKey:RH_SP_SITEMESSAGE_PAGINGPAGESIZE];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SITEMESSAGE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SiteMessage
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 站点信息 - 系统消息详情
-(void)startV3LoadSystemMessageDetailWithSearchId:(NSString *)searchId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:searchId forKey:RH_SP_SITEMESSAGEDETAIL_SEARCHID];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SITEMESSAGEDETAIL
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SiteMessageDetail
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 站点信息 - 系统消息标记已读
-(void)startV3LoadSystemMessageReadYesWithIds:(NSString *)ids
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:ids forKey:RH_SP_SITEMESSAGEREDAYES_IDS];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SITEMESSAGEREDAYES
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SystemMessageYes
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark - 站点信息 - 系统消息删除
-(void)startV3LoadSystemMessageDeleteWithIds:(NSString *)ids
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:ids forKey:RH_SP_SITEMESSAGEDELETE_IDS];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SITEMESSAGEDELETE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SystemMessageDelete
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark - 发送消息验证
-(void)startV3AddApplyDiscountsVerify
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ADDAPPLYDISCOUNTSVERIFY
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3AddApplyDiscountsVerify
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark - 消息中心 发送消息
-(void)startV3AddApplyDiscountsWithAdvisoryType:(NSString *)advisoryType
                                  advisoryTitle:(NSString *)advisoryTitle
                                advisoryContent:(NSString *)advisoryContent
                                           code:(NSString *)code
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:advisoryType forKey:RH_SP_ADDAPPLYDISCOUNTS_RESULTADVISORYTYPE];
    [dict setValue:advisoryTitle forKey:RH_SP_ADDAPPLYDISCOUNTS_RESULTADVISORYTITLE];
    [dict setValue:advisoryContent forKey:RH_SP_ADDAPPLYDISCOUNTS_RESULTADVISORYCONTENT];
    [dict setObject:code forKey:RH_SP_ADDAPPLYDISCOUNTS_CODE];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ADDAPPLYDISCOUNTS
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3AddApplyDiscounts
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - tabbar2 优惠活动主界面类型
-(void)startV3LoadDiscountActivityType
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_TABBAR2_GETACTIVITYTYPE_DISCOUNTS
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain,
                                     @"Cookie":userInfo_manager.sidString?:@""
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3PromoActivityType
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - tabbar2 优惠活动主界面列表
-(void)startV3LoadDiscountActivityTypeListWithKey:(NSString *)mKey
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ACTIVITYDATALIST
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{RH_SP_ACTIVITYDATALIST_SEARCHKEY:mKey?:@""
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3ActivityDetailList
                         scopeType:ServiceScopeTypePublic];
}


#pragma mark - 退出登录
-(void)startV3UserLoginOut
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_LOGINOUT
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3UserLoginOut
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 站点信息  我的消息
-(void)startV3SiteMessageMyMessageWithpageNumber:(NSInteger)pageNumber
                                        pageSize:(NSInteger)pageSize
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pageNumber) forKey:RH_SP_SITEMESSAGE_MYMESSAGE_PAGENUMBER];
    [dict setValue:@(pageSize) forKey:RH_SP_SITEMESSAGE_MYMESSAGE_PAGESIZE];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SITEMESSAGE_MYMESSAGE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SiteMessageMyMessage
                         scopeType:ServiceScopeTypePublic];
    
}
#pragma mark - 站点信息  我的消息详情
-(void)startV3SiteMessageMyMessageDetailWithID:(NSString *)mId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:mId forKey:RH_SP_SITEMESSAGE_MYMESSAGEDETAIL_ID];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SITEMESSAGE_MYMESSAGEDETAIL
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SiteMessageMyMessageDetail
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark - 站点信息 - 我的消息标记已读
-(void)startV3LoadMyMessageReadYesWithIds:(NSString *)ids
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:ids forKey:RH_SP_MYMESSAGEREDAYES_IDS];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_MYMESSAGEREDAYES
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3MyMessageMyMessageReadYes
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark - 站点信息 - 我的消息删除
-(void)startV3LoadMyMessageDeleteWithIds:(NSString *)ids
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:ids forKey:RH_SP_MYMESSAGEDELETE_IDS];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_MYMESSAGEDELETE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3MyMessageMyMessageDelete
                         scopeType:ServiceScopeTypePublic];
}


-(void)startv3GetGamesLink:(NSInteger)apiID
                 ApiTypeID:(NSInteger)apiTypeID
                   GamesID:(NSString*)gamesID
                 GamesCode:(NSString*)gamesCode
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(apiID) forKey:RH_SP_GAMESLINK_APIID];
    [dict setValue:@(apiTypeID) forKey:RH_SP_GAMESLINK_APITYPEID];
    if (gamesID){
        [dict setValue:gamesID forKey:RH_SP_GAMESLINK_GAMEID];
    }
    
    if (gamesCode){
        [dict setValue:gamesCode forKey:RH_SP_GAMESLINK_GAMECODE];
    }
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_GAMESLINK
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3GameLink
                         scopeType:ServiceScopeTypePublic];
    
}

#pragma mark - 获取games link for cheery
-(void)startv3GetGamesLinkForCheeryLink:(NSString*)gamelink
{
    if (gamelink.length && [gamelink containsString:@"?"]) {
        NSArray *tempArr = [gamelink componentsSeparatedByString:@"?"] ;
        NSString *gameLinkUrl = [tempArr objectAtIndex:0] ;
        NSArray *paraArr = [[tempArr objectAtIndex:1] componentsSeparatedByString:@"&"];
        NSString *temStr = [[paraArr  componentsJoinedByString:@","] stringByReplacingOccurrencesOfString:@"=" withString:@","];
        NSArray *temArr = [temStr componentsSeparatedByString:@","] ;
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary] ;
        for (int i= 0; i<temArr.count/2; i++) {
            [mDic setObject:[temArr objectAtIndex:2*i+1] forKey:[temArr objectAtIndex:i*2]];
        }
        [self _startServiceWithAPIName:self.appDelegate.domain
                            pathFormat:gameLinkUrl?:@""
                         pathArguments:nil
                       headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Host":self.appDelegate.headerDomain,
                                         @"Cookie":userInfo_manager.sidString?:@""
                                         }
                        queryArguments:mDic
                         bodyArguments:nil
                              httpType:HTTPRequestTypePost
                           serviceType:ServiceRequestTypeV3GameLinkForCheery
                             scopeType:ServiceScopeTypePublic];
    }
}

#pragma mark - 获取取款接口
-(void)startV3GetWithDraw
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_GETWITHDRAWUSERINFO
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain,
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3GetWithDrawInfo
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 提交取款信息
/**
 提交取款信息
 @param withdrawAmount 取款金额  Y
 @param gbToken 防重验证  Y
 */
-(void)startV3SubmitWithdrawAmount:(float)withdrawAmount
                         SafetyPwd:(NSString *)safetyPassword
                           gbToken:(NSString *)gbToken
                          CardType:(NSInteger)cardType  //（1：银行卡，2：比特币）
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(withdrawAmount) forKey:RH_SP_SUBMITWITHDRAWINFO_WITHDRAWAMOUNT];
    [dict setObject:gbToken?:@"" forKey:RH_SP_SUBMITWITHDRAWINFO_GBTOKEN];
    [dict setObject:@(cardType) forKey:RH_SP_SUBMITWITHDRAWINFO_REMITTANCEWAY] ;
    [dict setValue:safetyPassword?:@"" forKey:RH_SP_SUBMITWITHDRAWINFO_ORIGINPWD] ;
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SUBMITWITHDRAWINFO
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SubmitWithdrawInfo
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark - 获取游戏分类
-(void)startV3LoadGameTypeWithApiId:(NSInteger)apiId searchApiTypeId:(NSInteger)apiTypeId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(apiId) forKey:RH_SP_LOADGAMETYPE_SEARCH_APIID];
    [dict setObject:@(apiTypeId) forKey:RH_SP_LOADGAMETYPE_SEARCH_APITYPEID];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_LOADGAMETYPE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3LoadGameType
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 取款验证安全密码
-(void)startV3WithDrwaSafetyPasswordAuthentificationOriginPwd:(NSString *)originPwd
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:originPwd forKey:RH_GP_WITHDRWASAFETYPASSWORDAUTH_SAFETYPASSWORD];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_WITHDRWASAFETYPASSWORDAUTH
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SafetyPasswordAutuentification
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 获取手续费信息得到最终取款金额
-(void)startV3WithDrawFeeWithAmount:(CGFloat)amount
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%.2f",amount] forKey:RH_SP_WITHDRWAFEE_AMOUNT];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_WITHDRWAFEE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeWithDrawFee
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 获取站点时区
-(void)startV3SiteTimezone
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_TIMEZONEINFO
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeTimeZoneInfo
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 获取站点消息-系统消息&&我的消息 未读消息的条数
-(void)startV3LoadMessageCenterSiteMessageUnReadCount
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SITEMESSAGUNREADCOUNT
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeSiteMessageUnReadCount
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 分享接口
-(void)startV3LoadSharePlayerRecommend
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SHAREPLAYERRECOMMEND
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SharePlayerRecommend
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark -老用户验证登录
/**
 老用户验证登录
 
 @param token  登录返回的Token
 @param resultRealName 输入框真实姓名
 @param needRealName 默认传 YES
 @param resultPlayerAccount 用户名
 @param searchPlayerAccount 用户名
 @param tempPass 密码
 @param newPassword 密码
 @param passLevel 默认传 20
 */
-(void)startV3verifyRealNameForAppWithToken:(NSString *)token
                             resultRealName:(NSString *)resultRealName
                               needRealName:(BOOL)needRealName
                        resultPlayerAccount:(NSString *)resultPlayerAccount
                        searchPlayerAccount:(NSString *)searchPlayerAccount
                                   tempPass:(NSString *)tempPass
                                newPassword:(NSString *)newPassword
                                  passLevel:(NSInteger)passLevel
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:token forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_TOKEN];
    [dict setObject:resultRealName forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_RESULTREALNAME];
    [dict setObject:@(needRealName) forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_NEEDREALNAME];
    [dict setObject:resultPlayerAccount forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_RESULTPLAYERACCOUNT];
    [dict setObject:searchPlayerAccount forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_SEARCHACCOUNT];
    [dict setObject:tempPass forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_TEMPPASS];
    [dict setObject:newPassword forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_NEWPASSWORD];
    [dict setObject:@(passLevel) forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_PASSLEVEL];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_OLDUSERVERIFYREALNAMEFORAPP
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3VerifyRealNameForApp
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 获取用户资产信息
-(void)startV3GetUserAssertInfo
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_GETUSERASSERT
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3GETUSERASSERT
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 防止用户掉线
-(void)startV3RereshUserSessin
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] || [SITE_TYPE isEqualToString:@"integratedv3"]) {
        [self _startServiceWithAPIName:self.appDelegate.domain
                            pathFormat:RH_API_NAME_REFRESHLOGINSTATUS
                         pathArguments:nil
                       headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Host":self.appDelegate.headerDomain,
                                         @"Cookie":userInfo_manager.sidString
                                         }
                        queryArguments:nil
                         bodyArguments:nil
                              httpType:HTTPRequestTypePost
                           serviceType:ServiceRequestTypeV3RefreshSession
                             scopeType:ServiceScopeTypePublic];
    }
}

#pragma mark - 用户登录是否开启验证码
-(void)startV3IsOpenCodeVerifty
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ISOPENCODEVERIFTY
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3IsOpenCodeVerifty
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 通过GET请求登录接口获取SID
-(void)startV3RequsetLoginWithGetLoadSid
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_LOADSIDSTR
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeV3RequetLoginWithGetLoadSid
                         scopeType:ServiceScopeTypePublic];
    
}
-(void)startV3RequestDepositOrigin
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_DEPOSITE_DEPOSITEORIGIN
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3DepositeOrigin
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 注册初始化
-(void)startV3RegisetInit
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_REGISESTINIT
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3RegiestInit
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 注册验证码
-(void)startV3RegisetCaptchaCode
{
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;
        NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
        [self _startServiceWithAPIName:self.appDelegate.domain
                            pathFormat:RH_API_NAME_REGISESTCAPTCHACODE
                         pathArguments:nil
                       headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                         @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                         @"Cookie":userInfo_manager.sidString?:@"",
                                         @"Host":self.appDelegate.headerDomain
                                         }
                        queryArguments:@{@"_t":timeStr}
                         bodyArguments:nil
                              httpType:HTTPRequestTypePost
                           serviceType:ServiceRequestTypeV3RegiestCaptchaCode
                             scopeType:ServiceScopeTypePublic];
    }
}

#pragma mark - 注册提交
/**
 注册提交
 
 @param birth 生日
 @param sex 性别
 @param permissionPwd  安全码
 @param defaultTimezone 时区
 @param defaultLocale 默认语言
 @param phone 手机号
 @param realName 真实姓名
 @param defaultCurrency   货币
 @param password 密码
 @param question1 问题
 @param email 邮箱
 @param qq qq
 @param weixinValue 微信
 @param userName 用户名
 @param captchaCode 验证码
 */
-(void)startV3RegisetSubmitWithBirthday:(NSString *)birth
                                    sex:(NSString *)sex
                          permissionPwd:(NSString *)permissionPwd
                        defaultTimezone:(NSString *)defaultTimezone
                          defaultLocale:(NSString *)defaultLocale
                      phonecontactValue:(NSString *)phone
                               realName:(NSString *)realName
                        defaultCurrency:(NSString *)defaultCurrency
                               password:(NSString *)password
                              question1:(NSString *)question1
                             emailValue:(NSString *)email
                                qqValue:(NSString *)qq
                            weixinValue:(NSString *)weixinValue
                               userName:(NSString *)userName
                            captchaCode:(NSString *)captchaCode

                  recommendRegisterCode:(NSString *)recommendRegisterCode
                               editType:(NSString *)editType
                 recommendUserInputCode:(NSString *)recommendUserInputCode
                        confirmPassword:(NSString *)confirmPassword
                   confirmPermissionPwd:(NSString *)confirmPermissionPwd
                                answer1:(NSString *)answer1
                         termsOfService:(NSString *)termsOfService
                           requiredJson:(NSArray<NSString *> *)requiredJson
                              phoneCode:(NSString *)phoneCode
                             checkPhone:(NSString *)checkPhone
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:birth forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_BIRTHDAY];
    [dict setObject:sex forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_SEX];
    [dict setObject:permissionPwd forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_PERMISSIONPWD];
    [dict setObject:defaultTimezone forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_DEFAULTTIMEZONE];
    [dict setObject:phone forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_PHONECONTACTVALUE];
    [dict setObject:realName forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_REALNAME];
    [dict setObject:defaultLocale forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_DEFAULTLOCALE];
    [dict setObject:defaultCurrency forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_DEFAULTCURRENCY];
    [dict setObject:password forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_PASSWORD];
    [dict setObject:question1 forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_QUESTION];
    [dict setObject:email forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_EMAILCONTACTVALUE];
    [dict setObject:qq forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_QQCONTACTVALUE];
    [dict setObject:weixinValue forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_WEIXINCONTACTVALUE];
    [dict setObject:userName forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_USERNAME];
    [dict setObject:captchaCode forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_CAPCHACODE];
    [dict setObject:recommendRegisterCode forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_RECOMMENDREGISTERCODE];
    [dict setObject:editType forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_EDITTYPE];
    [dict setObject:recommendUserInputCode forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_RECOMMENDUSERINPUTCODE];
    [dict setObject:confirmPassword forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_CONFIRMPASSWORD];
    [dict setObject:confirmPermissionPwd forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_CONFIRMPERMISSIONPWD];
    [dict setObject:answer1 forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_SYSUSERPROTECTIONANSWER];
    [dict setObject:termsOfService forKey:RH_SP_OLDUSERVERIFYREALNAMEFORAPP_TERMOFSERVICE];
    [dict setObject:requiredJson forKey:@"requiredJson"];
    [dict setObject:phoneCode forKey:@"phoneCode"];
    [dict setObject:checkPhone forKey:@"checkPhone"];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_REGISESTSUBMIT
                     pathArguments:nil
                   headerArguments:@{@"Content-Type":@"application/x-www-form-urlencoded; charset=utf-8",
                                     @"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain,
                                     @"Cookie":[RH_UserInfoManager shareUserManager].sidString
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3RegiestSubmit
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark - 注册条款 
-(void)startV3RegisetTerm
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_REGISESTTERMS
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3RegiestTerm
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - V3  关于我们
-(void)startV3AboutUs
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ABOUTUS
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3AboutUs
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - V3  常见问题父级分类
-(void)startV3HelpFirstType
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_HELPFIRSTTYPE
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3FirstHelpFirstTyp
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - V3  常见问题二级分类
-(void)startV3HelpSecondTypeWithSearchId:(NSString *)searchId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:searchId forKey:RH_SP_HELPSECONDTYPE_SEARCHID];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_HELPSECONDTYPE
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeV3FirstHelpSecondTyp
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - V3  常见问题详情
-(void)startV3HelpDetailTypeWithSearchId:(NSString *)searchId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:searchId forKey:RH_SP_HELPSECONDTYPE_SEARCHID];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_HELPDETAIL
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeV3HelpDetail
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark 存款优惠
-(void)startV3DepositOriginSeachSaleRechargeAmount:(NSString *)rechargeAmount PayAccountDepositWay:(NSString *)payAccountDepositWay PayAccountID:(NSString *)payAccountID
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:rechargeAmount forKey:RH_SP_DEPOSITESEACHSALE_RECHARGEAMOUNT];
    [dict setValue:payAccountDepositWay forKey:RH_SP_DEPOSITESEACHSALE_DEPOSITEWAY];
    [dict setValue:payAccountID forKey:RH_SP_DEPOSITESEACHSALE_PAYACCOUNTID];
    
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_DEPOSITESEACHSALE
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3DepositOriginSeachSale
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark 比特币存款优惠
-(void)startV3DepositOriginSeachSaleBittionRechargeAmount:(CGFloat)rechargeAmount PayAccountDepositWay:(NSString *)payAccountDepositWay bittionTxid:(NSInteger)bankOrder PayAccountID:(NSString *)payAccountID
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(rechargeAmount) forKey:RH_SP_DEPOSITESEACHSALE_RESULTBITAMOUNT];
    [dict setValue:payAccountDepositWay forKey:RH_SP_DEPOSITESEACHSALE_DEPOSITEWAY];
    [dict setValue:@(bankOrder) forKey:RH_SP_DEPOSITESEACHSALE_RESULTBANKORDER];
    [dict setValue:payAccountID forKey:RH_SP_DEPOSITESEACHSALE_PAYACCOUNTID];
    
    
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_DEPOSITESEACHSALE
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3DepositOriginBittionSeachSale
                         scopeType:ServiceScopeTypePublic];
}


#pragma mark - V3  非免转额度转换初始化
-(void)startV3GetNoAutoTransferInfoInit
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_GETNOAUTOTRANSFERINFO
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }

                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3GetNoAutoTransferInfo
                         scopeType:ServiceScopeTypePublic];
}


#pragma mark - V3  非免转额度转换提交
-(void)startV3SubitTransfersMoneyToken:(NSString *)token
                           transferOut:(NSString *)transferOut
                          transferInto:(NSString *)transferInto
                        transferAmount:(float)transferAmount
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:token forKey:RH_SP_SUBTRANSFERMONEY_TOKEN];
    [dict setObject:transferOut forKey:RH_SP_SUBTRANSFERMONEY_TRANSFEROUT];
    [dict setObject:transferInto forKey:RH_SP_SUBTRANSFERMONEY_TRANSFERINTO];
    [dict setObject:@(transferAmount) forKey:RH_SP_SUBTRANSFERMONEY_TRANSFERAMOUNT];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SUBTRANSFERMONEY
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":userInfo_manager.sidString?:@"",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:dict
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SubmitTransfersMoney
                         scopeType:ServiceScopeTypePublic];
}


#pragma mark - V3  非免转额度转换异常再次请求
-(void)startV3ReconnectTransferWithTransactionNo:(NSString *)transactionNo
                                       withToken:(NSString *)token
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:transactionNo forKey:RH_SP_SUBTRANSFERMONEY_TRANSACTIONNO];
    [dict setObject:token forKey:RH_SP_SUBTRANSFERMONEY_TOKEN] ;
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_RECONNECTTRANSFER
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:dict
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3ReconnectTransfer
                         scopeType:ServiceScopeTypePublic];
}


#pragma mark - V3  非免转刷新单个
-(void)startV3RefreshApiWithApiId:(NSString *)apiId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:apiId forKey:RH_SP_REFRESHAPI_APIID];
    
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_REFRESHAPI
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:dict
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3RefreshApi
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - V3 线上支付提交存款
-(void)startV3OnlinePayWithRechargeAmount:(NSString *)amount
                             rechargeType:(NSString *)rechargeType
                             payAccountId:(NSString*)payAccountId
                               activityId:(NSString *)activityId
                             bankNameCode:(NSString *)bankNameCode
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     [dict setValue:amount forKey:RH_SP_ONLINEPAY_RECHARGEAMOUNT];
    [dict setValue:rechargeType forKey:RH_SP_ONLINEPAY_RECHARGETYPE];
    [dict setValue:payAccountId forKey:RH_SP_ONLINEPAY_PAYACCOUNTID];
    [dict setValue:activityId forKey:RH_SP_ONLINEPAY_ACTIVITYID];
    [dict setValue:bankNameCode forKey:RH_SP_ONLINEPAY_PAYERBANK];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ONLINEPAY
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:dict
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3OnlinePay
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - V3 扫码支付提交存款
-(void)startV3ScanPayWithRechargeAmount:(NSString *)amount
                           rechargeType:(NSString *)rechargeType
                           payAccountId:(NSInteger)payAccountId
                          payerBankcard:(NSInteger)payerBankcard
                             activityId:(NSInteger)activityId
                               account:(NSString *)account
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:amount forKey:RH_SP_SCANPAY_RECHARGEAMOUNT];
    [dict setObject:rechargeType forKey:RH_SP_SCANPAY_RECHARGETYPE];
//    [dict setObject:@(payAccountId) forKey:RH_SP_SCANPAY_PAYACCOUNTID];
    [dict setObject:@(payerBankcard) forKey:RH_SP_SCANPAY_PAYERBANKCARD];
    [dict setObject:@(activityId) forKey:RH_SP_SCANPAY_ACTIVITYID];
    [dict setValue:account forKey:RH_SP_SCANPAY_PAYACCOUNTID];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SCANPAY
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:dict
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3ScanPay
                         scopeType:ServiceScopeTypePublic];
}

//#pragma mark - V3 易收付
//-(void)startV3EasyWithRechargeAmount:(NSString *)amount
//                                 cid:(NSString *)cid
//                                 uid:(NSString *)uid
//                                time:(NSString *)time
//                            order_id:(NSString *)order_id
//                                  ip:(NSString *)ip
//                                sign:(NSString *)sign
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:amount forKey:RH_SP_EASYPAY_AMOUNT];
//    [dict setObject:cid forKey:RH_SP_EASYPAY_CID];
//    [dict setObject:uid forKey:RH_SP_EASYPAY_UID];
//    [dict setObject:time forKey:RH_SP_EASYPAY_TIME];
//    [dict setObject:order_id forKey:RH_SP_EASYPAY_ORDER_ID];
//    [dict setValue:ip forKey:RH_SP_EASYPAY_IP];
//    [dict setValue:sign forKey:RH_SP_EASYPAY_SIGN];
//    [self _startServiceWithAPIName:nil
//                        pathFormat:RH_API_NAME_EASYPAY
//                     pathArguments:nil
//                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
//                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
//                                     @"Host":self.appDelegate.headerDomain
//                                     }
//                    queryArguments:nil
//                     bodyArguments:dict
//                          httpType:HTTPRequestTypePost
//                       serviceType:ServiceRequestTypeV3ScanPay
//                         scopeType:ServiceScopeTypePublic];
//}

#pragma mark -  V3 网银支付提交存款
-(void)startV3CompanyPayWithRechargeAmount:(NSString *)amount
                              rechargeType:(NSString *)rechargeType
                              payAccountId:(NSString *)payAccountId
                                 payerName:(NSString *)payerName
                                activityId:(NSInteger)activityId
{
    payerName = [payerName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:amount forKey:RH_SP_COMPANYPAY_RECHARGEAMOUNT];
    [dict setObject:rechargeType forKey:RH_SP_COMPANYPAY_RECHARGETYPE];
    [dict setObject:payAccountId forKey:RH_SP_COMPANYPAY_PAYACCOUNTID];
    [dict setObject:payerName forKey:RH_SP_COMPANYPAY_PAYERNAME];
    [dict setObject:@(activityId) forKey:RH_SP_COMPANYPAY_ACTIVITYID];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_COMPANYPAY
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:dict
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3CompanyPay
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark -  V3 柜台机支付提交存款
-(void)startV3CounterPayWithRechargeAmount:(NSString *)amount
                              rechargeType:(NSString *)rechargeType
                              payAccountId:(NSString *)payAccountId
                                 payerName:(NSString *)payerName
                           rechargeAddress:(NSString *)rechargeAddress
                                activityId:(NSInteger)activityId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject: amount forKey:RH_SP_COMPANYPAY_RECHARGEAMOUNT];
    [dict setObject:rechargeType forKey:RH_SP_COMPANYPAY_RECHARGETYPE];
    [dict setObject:payAccountId forKey:RH_SP_COMPANYPAY_PAYACCOUNTID];
    [dict setObject:payerName forKey:RH_SP_COMPANYPAY_PAYERNAME];
    [dict setObject:rechargeAddress forKey:RH_SP_COMPANYPAY_RECHARGEADDRESS];
    [dict setObject:@(activityId) forKey:RH_SP_COMPANYPAY_ACTIVITYID];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_COMPANYPAY
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:dict
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3CounterPay
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark - V3 电子支付提交存款
-(void)startV3ElectronicPayWithRechargeAmount:(NSString *)amount
                                 rechargeType:(NSString *)rechargeType
                                 payAccountId:(NSString *)payAccountId
                                    bankOrder:(NSString *)bankOrder
                                    payerName:(NSString *)payerName
                                payerBankcard:(NSString *)payerBankcard
                                   activityId:(NSInteger)activityId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:amount forKey:RH_SP_ELECTRONICPAY_RECHARGEAMOUNT];
    [dict setObject:rechargeType forKey:RH_SP_ELECTRONICPAY_RECHARGETYPE];
    [dict setObject:payAccountId forKey:RH_SP_ELECTRONICPAY_PAYACCOUNTID];
    [dict setObject:bankOrder?:@"" forKey:RH_SP_ELECTRONICPAY_BANKORDER];
    [dict setObject:payerName forKey:RH_SP_ELECTRONICPAY_PAYERNAME];
    [dict setObject:payerBankcard forKey:RH_SP_ELECTRONICPAY_PAYERBANKCARD];
    [dict setObject:@(activityId) forKey:RH_SP_ELECTRONICPAY_ACTIVITYID];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ELECTRONICPAY
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:dict
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3ElectronicPay
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark - V3 支付宝电子支付提交存款
-(void)startV3AlipayElectronicPayWithRechargeAmount:(NSString *)amount
                                 rechargeType:(NSString *)rechargeType
                                 payAccountId:(NSString *)payAccountId
                                    bankOrder:(NSString *)bankOrder
                                    payerName:(NSString *)payerName
                                payerBankcard:(NSString *)payerBankcard
                                   activityId:(NSInteger)activityId
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:amount forKey:RH_SP_ELECTRONICPAY_RECHARGEAMOUNT];
    [dict setObject:rechargeType forKey:RH_SP_ELECTRONICPAY_RECHARGETYPE];
    [dict setObject:payAccountId forKey:RH_SP_ELECTRONICPAY_PAYACCOUNTID];
    [dict setObject:bankOrder?:@"" forKey:RH_SP_ELECTRONICPAY_BANKORDER];
    [dict setObject:payerName forKey:RH_SP_ELECTRONICPAY_PAYERNAME];
    [dict setObject:payerBankcard forKey:RH_SP_ELECTRONICPAY_PAYERBANKCARD];
    [dict setObject:@(activityId) forKey:RH_SP_ELECTRONICPAY_ACTIVITYID];
    
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ELECTRONICPAY
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:dict
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3AlipayElectronicPay
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - V3 比特币支付提交存款
-(void)startV3BitcoinPayWithRechargeType:(NSString *)rechargeType
                            payAccountId:(NSString *)payAccountId
                              activityId:(NSInteger)activityId
                              returnTime:(NSString *)returnTime
                           payerBankcard:(NSString *)payerBankcard
                               bitAmount:(float)bitAmount
                           bankOrderTxID:(NSString *)bankOrder
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:rechargeType forKey:RH_SP_BITCOINPAY_RECHARGETYPE];
    [dict setObject:payAccountId forKey:RH_SP_BITCOINPAY_PAYACCOUNTID];
    [dict setObject:@(activityId) forKey:RH_SP_BITCOINPAY_ACTIVITYID];
    [dict setObject:returnTime forKey:RH_SP_BITCOINPAY_RETURNTIME];
    [dict setObject:payerBankcard forKey:RH_SP_BITCOINPAY_PAYERBANKCARD];
    [dict setObject:@(bitAmount) forKey:RH_SP_BITCOINPAY_BITAMOUNT];
    [dict setObject:bankOrder forKey:RH_SP_BITCOINPAY_BANKORDER];
    
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_BITCOINPAY
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:dict
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3BitcoinPay
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - V3 一键刷新
-(void)startV3OneStepRefresh
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ONESTEPREFRESH
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3OneStepRefresh
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark - 存款渠道初始化
-(void)startV3RequestDepositOriginChannel:(NSString *)httpCode
{
    NSString *pathFormat = [NSString stringWithFormat:@"%@%@.html",RH_API_DEPOSITE_DEPOSITEORIGINCHANNEL,httpCode];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:pathFormat
                     pathArguments:nil
                   headerArguments:@{
                                     @"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain,
                                     @"Cookie":userInfo_manager.sidString?:@""
                                     }
                    queryArguments:nil 
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3DepositeOriginChannel
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 获取手机验证码
-(void)startV3GetPhoneCodeWithPhoneNumber:(NSString *)phoneNumber
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:phoneNumber forKey:@"phone"];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:@"mobile-api/origin/sendPhoneCode.html"
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:dict
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3GetPhoneCode
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark ==============获取客服接口================
-(void)startV3GetCustomService
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_CUSTOMSERVICE
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3CustomService
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark ==============提交crash日志================
-(void)startV3CollectAppDomainError:(NSString *)siteId userNameStr:(NSString *)userName lastLoginTime:(NSString *)lastLoginTime domain:(NSString *)domain ipStr:(NSString *)ip errorMessageStr:(NSString *)errorMessage codeStr:(NSString *)codeStr markStr:(NSString *)mark typeStr:(NSString *)typeStr versionName:(NSString *)versionName channelStr:(NSString *)channel sysCodeStr:(NSString *)sysCode brandsStr:(NSString *)brands modelStr:(NSString *)modelStr
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_CUSTOMSERVICE
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3CustomService
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark ==============系统公告弹框================
-(void)startV3NoticePopup
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_WEBSOCKETMDCETER
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":[RH_UserInfoManager shareUserManager].sidString,
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3NoticePopup
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark ==============分享好友记录================
-(void)startV3SharePlayerRecordStartTime:(NSString *)startTime endTime:(NSString *)endTime pageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pageSize
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:startTime forKey:RH_SP_GETPLAYERRECOMMENDRECORD_STARTTIME];
    [dict setValue:endTime forKey:RH_SP_GETPLAYERRECOMMENDRECORD_ENDTIME];
    [dict setValue:@(pageNumber) forKey:RH_SP_GETPLAYERRECOMMENDRECORD_PAGENUMBER];
    [dict setValue:@(pageSize) forKey:RH_SP_GETPLAYERRECOMMENDRECORD_PAGESIZE];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_GETPLAYERRECOMMENDRECORD
                     pathArguments:nil
                   headerArguments:@{
//                                     @"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":[RH_UserInfoManager shareUserManager].sidString,
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SharePlayerRecord
                         scopeType:ServiceScopeTypePublic];
}


-(void)startV3InitAd
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_INITAD
                     pathArguments:nil
                   headerArguments:@{
                                     @"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeV3INITAD
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 找回密码

- (void)findUserPhone:(NSString *)username
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_ForgetPsw_FINDPHONE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":[RH_UserInfoManager shareUserManager].sidString,
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{@"username":username}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3FindUserPhone
                         scopeType:ServiceScopeTypePublic];
}

- (void)forgetPswSendCode:(NSString *)encryptedId
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_ForgetPsw_SendCode
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":[RH_UserInfoManager shareUserManager].sidString,
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{@"encryptedId":encryptedId}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3ForgetPswSendCode
                         scopeType:ServiceScopeTypePublic];
}

- (void)forgetPswCheckCode:(NSString *)code
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_ForgetPsw_CheckCode
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":[RH_UserInfoManager shareUserManager].sidString,
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{@"code":code}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3ForgetPswCheckCode
                         scopeType:ServiceScopeTypePublic];
}

- (void)finbackLoginPsw:(NSString *)username psw:(NSString *)psw
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_ForgetPsw_FindbackPsw
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":[RH_UserInfoManager shareUserManager].sidString,
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{@"username":username,@"newPassword":psw}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3ForgetPswFindbackPsw
                         scopeType:ServiceScopeTypePublic];
}

- (void)checkForgetPswStatus
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_ForgetPsw_CheckStatus
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":[RH_UserInfoManager shareUserManager].sidString,
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3ForgetPswCheckStatus
                         scopeType:ServiceScopeTypePublic];

}

#pragma mark - 绑定手机

- (void)getUserPhone
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_BINDPHONE_GETPHONE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":[RH_UserInfoManager shareUserManager].sidString,
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3GetUserPhone
                         scopeType:ServiceScopeTypePublic];
}

- (void)bindPhoneSendCode:(NSString *)phone
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_BINDPHONE_SENDCODE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":[RH_UserInfoManager shareUserManager].sidString,
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{@"phone":phone}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3BindSendCode
                         scopeType:ServiceScopeTypePublic];
}

- (void)bindPhone:(NSString *)phone originalPhone:(NSString *)originalPhone code:(NSString *)code
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_BINDPHONE_BINDPHONE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":[NSString stringWithFormat:@"app_ios, iPhone, %@.%@",GB_CURRENT_APPVERSION,RH_APP_VERCODE],
                                     @"Cookie":[RH_UserInfoManager shareUserManager].sidString,
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{@"search.contactValue":phone,@"code":code,@"oldPhone":originalPhone}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3BindPhone
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - 获取动态IP列表 该IP列表用于获取check ips

- (void)fetchHost:(NSString *)url
{
    RH_HTTPRequest * httpRequest = [[RH_HTTPRequest alloc] initWithAPIName:url
                                                                pathFormat:nil
                                                             pathArguments:nil
                                                            queryArguments:nil
                                                           headerArguments:nil
                                                             bodyArguments:nil
                                                                      type:HTTPRequestTypeGet];
    
    httpRequest.timeOutInterval = _timeOutInterval ;
    //开始请求
    [self _startHttpRequest:httpRequest forType:ServiceRequestTypeFetchHost scopeType:ServiceScopeTypePublic];
}
- (void)fetchH5ip{
    if ([CheckTimeManager shared].times) {
        NSInteger num = [[CheckTimeManager shared].times integerValue];
        NSInteger index = num+1;
        [CheckTimeManager shared].times = [NSString stringWithFormat:@"%ld",(long)index];
    }else{
        [CheckTimeManager shared].times = @"0";
    }
    
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:@"mobile-api/app/getHost.html"
                     pathArguments:nil
                   headerArguments:@{
                                     @"User-Agent":@"app_ios, iPhone",
                                     @"Host":self.appDelegate.headerDomain
                                     }
                    queryArguments:@{@"times":[CheckTimeManager shared].times}
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeFetchH5Ip
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark -
- (NSMutableDictionary *)doSometiongMasks {
    return _doSometiongMasks ?: (_doSometiongMasks = [NSMutableDictionary dictionary]);
}

//开始请求前可能会做一些比较费时的事，比如图像压缩，数据转换,使用该方法在后台进行
//block为长时间处理事情的block,当处理完成并且没有取消服务，则会调用completedBlock
- (void)_doSometiongInBackgroud:(void(^)(void))block
             beforeStartService:(ServiceRequestType)type
                 completedBlock:(void(^)(void))completedBlock
{
    NSString * token = getUniqueID();
    [self.doSometiongMasks setObject:token forKey:@(type)];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        if (block) {
            block();
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            //没有取消
            if ([self.doSometiongMasks[@(type)] isEqualToString:token]) {
                [self.doSometiongMasks removeObjectForKey:@(type)];

                if (completedBlock) {
                    completedBlock();
                }
            }
        });
    });
}

- (NSString *)uniqueID {
    return _uniqueID ?: (_uniqueID = getUniqueID());
}

- (NSString *)_keyForSerivceType:(ServiceRequestType)type {
    return [NSString stringWithFormat:@"%@_%d",self.uniqueID,(int)type];
}

- (void)_startServiceWithAPIName:(NSString *)apiName
                      pathFormat:(NSString *)pathFormat
                   pathArguments:(NSArray *)pathArguments
                 headerArguments:(NSDictionary *)headerArguments
                  queryArguments:(NSDictionary *)queryArguments
                   bodyArguments:(id)bodyArguments
                        httpType:(HTTPRequestType)httpType
                     serviceType:(ServiceRequestType)type
                       scopeType:(ServiceScopeType)scopeType
{
    NSMutableDictionary *queryArgs = [NSMutableDictionary dictionary] ;
    
    if (queryArguments.count){
        [queryArgs addEntriesFromDictionary:queryArguments] ;
    }
   
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
        [queryArgs setValue:@"app_ios" forKey:RH_SP_COMMON_V3_OSTYPE] ;
        [queryArgs setValue:@"True" forKey:RH_SP_COMMON_V3_ISNATIVE] ;
        [queryArgs setValue:RH_SP_COMMON_V3_VERSION_VALUE forKey:RH_SP_COMMON_V3_VERSION] ;
        [queryArgs setValue:@"zh_CN" forKey:RH_SP_COMMON_V3_LOCALE] ;//zh_CN,zh_TW,en_US,ja_JP
        
        //white,black,blue,red
        if ([THEMEV3 isEqualToString:@"green"]){
            [queryArgs setValue:@"green" forKey:RH_SP_COMMON_V3_THEME] ;
        }else if ([THEMEV3 isEqualToString:@"red"]){
            [queryArgs setValue:@"green" forKey:RH_SP_COMMON_V3_THEME] ;
        }else if ([THEMEV3 isEqualToString:@"black"]){
            [queryArgs setValue:@"black" forKey:RH_SP_COMMON_V3_THEME] ;
        }else if ([THEMEV3 isEqualToString:@"orange"]){
            [queryArgs setValue:@"green" forKey:RH_SP_COMMON_V3_THEME] ;
        }else if ([THEMEV3 isEqualToString:@"blue"]){
            [queryArgs setValue:@"green" forKey:RH_SP_COMMON_V3_THEME] ;
        }else if ([THEMEV3 isEqualToString:@"default"]){
            [queryArgs setValue:@"blue" forKey:RH_SP_COMMON_V3_THEME] ;
        }else{
            [queryArgs setValue:@"blue" forKey:RH_SP_COMMON_V3_THEME] ;
        }
        
        CLScreenSizeType screenType = mainScreenType();
        switch (screenType) {
            case CLScreenSizeTypeBig:
                [queryArgs setValue:@"3x" forKey:RH_SP_COMMON_V3_RESOLUTION] ;
                break;
            default:
                [queryArgs setValue:@"2x" forKey:RH_SP_COMMON_V3_RESOLUTION] ;
                break;
        }
    }
   
    NSMutableDictionary *headerArg = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"close",@"Connection", nil];
    if (headerArguments) {
        [headerArg addEntriesFromDictionary:headerArguments];
    }
    if (![[headerArg allKeys] containsObject:@"Cookie"]) {
        [headerArg setValue:userInfo_manager.sidString?:@""forKey:@"Cookie"];
    }
    RH_HTTPRequest * httpRequest = [[RH_HTTPRequest alloc] initWithAPIName:apiName
                                                                pathFormat:pathFormat
                                                             pathArguments:pathArguments
                                                            queryArguments:queryArgs
                                                           headerArguments:headerArg
                                                             bodyArguments:bodyArguments
                                                                      type:httpType];
    
    httpRequest.timeOutInterval = _timeOutInterval ;
    //开始请求
    [self _startHttpRequest:httpRequest forType:type scopeType:scopeType];
}


- (void)_startFormDataServiceWithDatas:(NSString *)apiName
                            pathFormat:(NSString *)pathFormat
                         pathArguments:(NSArray *)pathArguments
                       headerArguments:(NSDictionary *)headerArguments
                        queryArguments:(NSDictionary *)queryArguments
                           serviceType:(ServiceRequestType)type
                             scopeType:(ServiceScopeType)scopeType
                                 Datas:(NSArray *)datas
{
//    NSMutableDictionary *queryArgs = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",RH_SP_OSTYPE,RH_CURRENT_VERSION,RH_SP_VERSION,getDeviceID(),RH_SP_DEVICEID, nil] ;
    NSMutableDictionary *queryArgs = [NSMutableDictionary dictionary] ;

    if (queryArguments.count){
        [queryArgs addEntriesFromDictionary:queryArguments] ;
    }

    RH_HTTPRequest *httpRequest = [[RH_HTTPRequest alloc] initWithFromDataAPIName:apiName
                                                                       pathFormat:pathFormat
                                                                    pathArguments:pathArguments
                                                                   queryArguments:queryArgs
                                                                  headerArguments:headerArguments] ;
    
    httpRequest.timeOutInterval = _timeOutInterval ;

    for (id data in datas) {
        if ([data isKindOfClass:[NSData class]]) {
            [httpRequest addData:data fileName:@"image.jpg"  contentType:@"image/jpeg" forKey:@"myfile"];
        }else if ([data isKindOfClass:[UIImage class]]) {
            [httpRequest addImage:data imageName:@"image.jpg" forKey:@"myfile"];
        }
    }

    [self _startHttpRequest:httpRequest forType:type scopeType:scopeType] ;
}


- (void)_startHttpRequest:(RH_HTTPRequest *)httpRequest
                  forType:(ServiceRequestType)type
                scopeType:(ServiceScopeType)scopeType
{
    [self cancleServiceWithType:type];

    NSValue * key = @(type);
    [self.httpRequests setObject:httpRequest forKey:key];
    [self.requestingMarks setObject:@(YES) forKey:key];

    //开始请求
    httpRequest.delegate = self;
    [httpRequest startRequestWithContext:[[RH_ServiceRequestContext alloc] initWithSerivceType:type scopeType:scopeType]];
}

#pragma mark -
- (void)dealloc
{
    _delegate = nil;
    [self cancleAllServices];
}

#pragma mark -
- (NSMutableDictionary *)httpRequests {
    return _httpRequests ?: (_httpRequests = [NSMutableDictionary dictionary]);
}

- (NSMutableDictionary *)requestingMarks {
    return _requestingMarks ?: (_requestingMarks = [NSMutableDictionary dictionary]);
}

- (void)cancleAllServices
{
    for (RH_HTTPRequest * httpRequest in _httpRequests.allValues) {
        httpRequest.delegate = nil;
        [httpRequest cancleRequest];
    }

    [_httpRequests removeAllObjects];
    [_requestingMarks removeAllObjects];
    [_contexts removeAllObjects];
    [_doSometiongMasks removeAllObjects];
}

- (void)cancleServiceWithType:(ServiceRequestType)serivceType
{
    NSValue * key = @(serivceType);

    if (_requestingMarks[key]) {

        //取消请求
        RH_HTTPRequest * httpRequest = _httpRequests[key];
        if (httpRequest) {
            httpRequest.delegate = nil;
            [httpRequest cancleRequest];
            [_httpRequests removeObjectForKey:key];
        }

        //移除请求掩码
        [_requestingMarks removeObjectForKey:key];

        //移除上下文
        [self removeContextForType:serivceType];
    }

    [_doSometiongMasks removeObjectForKey:key];
}

- (BOOL)isRequesting {
    return  _requestingMarks.count != 0 || _doSometiongMasks.count != 0;
}

- (BOOL)isRequestingWithType:(ServiceRequestType)serivceType {
    return _requestingMarks[@(serivceType)] || _doSometiongMasks[@(serivceType)];
}

- (NSUInteger)requestsCount {
    return _requestingMarks.count + _doSometiongMasks.count;
}

#pragma mark- property
- (NSMutableDictionary *)contexts {
    return _contexts ?: (_contexts = [NSMutableDictionary dictionary]);
}

- (void)setContext:(id)context forType:(ServiceRequestType)serivceType
{
    if (context == nil) {
        [self removeContextForType:serivceType];
    }else{
        [self.contexts setObject:context forKey:@(serivceType)];
    }
}

- (id)contextForType:(ServiceRequestType)serivceType {
    return [_contexts objectForKey:@(serivceType)];
}

- (void)removeContextForType:(ServiceRequestType)serivceType {
    [_contexts removeObjectForKey:@(serivceType)];
}

#pragma mark - Handle request
- (BOOL)httpRequest:(id<CLHTTPRequestProtocol>)request
           response:(NSHTTPURLResponse *)response
         handleData:(id)data
         reslutData:(__autoreleasing id *)reslutData
              error:(NSError *__autoreleasing *)error
{
    NSData *tmpData = ConvertToClassPointer(NSData, data) ;
    NSString *tmpResult = [tmpData mj_JSONString] ;
    NSLog(@"tmpResult==%@",tmpResult);
    
    
    RH_ServiceRequestContext * context = [request context];
    ServiceRequestType type = context.serivceType;
    if (type == ServiceRequestTypeUserAutoLogin) {
        if ([tmpResult containsString:@"站点维护"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"607",@"textOne",nil];
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                return ;
            });
        }
    }
    
//    NSData *tmpDatas = ConvertToClassPointer(NSData, data) ;
//    NSString *tmpResults = [tmpDatas mj_JSONString] ;

    if (type == ServiceRequestTypeDomainCheck)
    {//处理结果数据
        NSData *tmpData = ConvertToClassPointer(NSData, data) ;
        NSString *tmpResult = [tmpData mj_JSONString] ;
        if ([[tmpResult lowercaseString] containsString:@"ok"]){ //域名响应ok
            NSString* reqUrl = response.URL.absoluteString.lowercaseString;
            if ([reqUrl hasPrefix:@"https://"]) {
                *reslutData = @(YES) ;
            }else{
                *reslutData = @(NO) ;
            }
            if ([reqUrl containsString:@"https"]&&[reqUrl containsString:@"8989"]) {
                self.appDelegate.checkType = @"https+8989";
            }
            else if ([reqUrl containsString:@"http"]&&[reqUrl containsString:@"8787"]){
                self.appDelegate.checkType = @"http+8787";
            }
            else
            {
                if ([reqUrl containsString:@"https"]) {
                    self.appDelegate.checkType = @"https";
                }
                else {
                    self.appDelegate.checkType = @"http";
                }
            }
            if (response.statusCode==605){
                dispatch_async(dispatch_get_main_queue(), ^{
                    showAlertView(@"ip被限制", nil) ;
                    return ;
                });
            }
            
        }else{
            *error = [NSError resultDataNoJSONError] ;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *checkDomainStr = ConvertToClassPointer(NSString, [self contextForType:ServiceRequestTypeDomainCheck]) ;
                NSString *errorCode = [NSString stringWithFormat:@"%ld",response.statusCode] ;
                NSString *errorMessage = [response.description copy] ;
                [[RH_UserInfoManager shareUserManager].domainCheckErrorList addObject:@{RH_SP_COLLECTAPPERROR_DOMAIN:checkDomainStr?:@"",
                                                                                        RH_SP_COLLECTAPPERROR_CODE:errorCode,
                                                                                        RH_SP_COLLECTAPPERROR_ERRORMESSAGE:errorMessage,
                                                                                        }] ;
            });
        }
        
        return YES ;
        
    }else if (type == ServiceRequestTypeGetCustomService){
        NSData *tmpData = ConvertToClassPointer(NSData, data) ;
        NSString *tmpResult = [tmpData mj_JSONString] ;
        if ([tmpResult.lowercaseString hasPrefix:@"http://"] || [tmpResult.lowercaseString hasPrefix:@"https://"]){
            *reslutData = tmpResult ;
            [self.appDelegate updateServicePath:[tmpResult stringByReplacingOccurrencesOfString:@"\n" withString:@""]] ;
        }else{
            *error = [NSError resultDataNoJSONError] ;
        }
        
        return YES ;
    }else if (type == ServiceRequestTypeDemoLogin){//处理结果数据
        NSData *tmpData = ConvertToClassPointer(NSData, data) ;
        NSString *tmpResult = [tmpData mj_JSONString] ;
        
        if ([[tmpResult lowercaseString] containsString:@"true"]){ //域名响应ok
            *reslutData = @(YES) ;
            
            if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
                [self startV3UserInfo] ;
            }
        }else{
            *reslutData = @(NO) ;
        }
        return YES ;
    }
    else if (type == ServiceRequestTypeObtainVerifyCode ||
              type == ServiceRequestTypeV3SafetyObtainVerifyCode||type== ServiceRequestTypeV3RegiestCaptchaCode){
        NSData *tmpData = ConvertToClassPointer(NSData, data) ;
        UIImage *image = [[UIImage alloc] initWithData:tmpData] ;
        *reslutData = image ;
        return YES ;
        
    }else if (type == ServiceRequestTypeTestUrl){
//        NSData *tmpData = ConvertToClassPointer(NSData, data) ;
//        NSString *tmpResult = [tmpData mj_JSONString] ;
    }else if (type == ServiceRequestTypeAPIRetrive){ //游戏 回收api
        NSError * tempError = nil;
        NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                                                      error:&tempError] : @{};
        *reslutData = @([dataObject boolValueForKey:@"isSuccess"]) ;
        return YES ;
    }else if (type == ServiceRequestTypeCollectAPPError){
        NSError * tempError = nil;
        NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                                                      error:&tempError] : @{};
        *reslutData = dataObject ;
        return YES ;
    }
    
    else if (type == ServiceRequestTypeV3FindUserPhone){
        NSError * tempError = nil;
        NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                                                      error:&tempError] : @{};
        *reslutData = dataObject ;
        return YES ;
    }
//    else if (type == ServiceRequestTypeV3NoticePopup){
//    else if (type == ServiceRequestTypeV3DepositeOriginChannel){
//        NSError * tempError = nil;
//        NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
//                                                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
//                                                                                      error:&tempError] : @{};
//        *reslutData = dataObject ;
//        return YES ;
//    }
    else if (type == ServiceRequestTypeV3CustomService){
        NSError * tempError = nil;
        NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                                                      error:&tempError] : @{};
        *reslutData = dataObject ;
        return YES ;
    }
    else if (type == ServiceRequestTypeV3OnlinePay){
        NSError * tempError = nil;
        NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                                                      error:&tempError] : @{};
        *reslutData = dataObject ;
        NSString *errorMessage = [response.description copy] ;
        return YES ;
    }
    else if (type == ServiceRequestTypeV3RegiestSubmit){
        NSError * tempError = nil;
        NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                                                      error:&tempError] : @{};
        *reslutData = dataObject ;
        return YES ;
    }
//        NSError * tempError = nil;
//        NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
//                                                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
//                                                                                      error:&tempError] : @{};
//        *reslutData = dataObject ;
//        return YES ;
//    }
    else if (type == ServiceRequestTypeV3RequetLoginWithGetLoadSid)
    {
        NSString *responseStr = response.allHeaderFields[@"Set-Cookie"] ;
        NSMutableArray *mArr = [NSMutableArray array] ;
        if (isSidStr(responseStr)) {
            [mArr addObjectsFromArray:matchLongString(responseStr)] ;
        }
        if (mArr.count>0) {
            userInfo_manager.sidString = [NSString stringWithFormat:@"SID=%@",[mArr lastObject]] ;
        }
        
    }
  
//    
   
    //json解析
    NSError * tempError = nil;
    NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                                                  error:&tempError] : @{};
    if (dataObject&&![dataObject isEqual:@""]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataObject options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString11 = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString11);
    }
    if (tempError) { //json解析错误
        if (type==ServiceRequestTypeDomainList){ //当主域名 获取失败时 直接显示系统的 response 信息。
            tempError = ERROR_CREATE(HTTPRequestResultErrorDomin,
                                     response.statusCode,
                                     response.description,nil);
        }else{
            tempError = [NSError resultErrorWithURLResponse:response]?:[NSError resultDataNoJSONError];
        }
    }else{
        if ([SITE_TYPE isEqualToString:@"integratedv3oc"] && type != ServiceRequestTypeDomainList ){
            if (dataObject != nil && ![dataObject isEqual:@""]) {
                if ([dataObject integerValueForKey:RH_GP_V3_ERROR defaultValue:0]!=0) { //结果错误
                    tempError = [NSError resultErrorWithResultInfo:dataObject];
                }
            }
        }
    }
 
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] &&
        (type==ServiceRequestTypeUserLogin || type == ServiceRequestTypeUserAutoLogin)){//针对原生 ，检测http 302 错误
        
        if (response.statusCode==302){
            tempError = ERROR_CREATE(HTTPRequestResultErrorDomin,302,@"login fail",dataObject);
        }
    }
    
    if (error) {
        *error = tempError;
    }
    //结果成功，开始处理数据
    if (tempError == nil) {

        id resultSendData = nil;
        switch (type) {
//            case ServiceRequestTypeDomainList:
//            {
//
//                resultSendData = ConvertToClassPointer(NSArray, dataObject) ;
//
//            }
//                break ;
                
            case ServiceRequestTypeUpdateCheck:
            case ServiceRequestTypeV3UpdateCheck:
            {
                resultSendData = [[RH_UpdatedVersionModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, dataObject)] ;
            }
                break ;
              
           case ServiceRequestTypeUserLogin:
           case ServiceRequestTypeUserAutoLogin:
            {
                NSString *responseStr = response.allHeaderFields[@"Set-Cookie"] ;
                NSMutableArray *mArr = [NSMutableArray array] ;
                if (isSidStr(responseStr)) {
                [mArr addObjectsFromArray:matchLongString(responseStr)] ;
                }
                if (mArr.count>0) {
                     userInfo_manager.sidString = [NSString stringWithFormat:@"SID=%@",[mArr lastObject]] ;
                }
                NSLog(@"....SID INFO...get.sid:%@",responseStr) ;
                resultSendData = ConvertToClassPointer(NSDictionary, dataObject) ;
                if ([ConvertToClassPointer(NSDictionary, resultSendData) boolValueForKey:@"success" defaultValue:FALSE] &&
                    [SITE_TYPE isEqualToString:@"integratedv3oc"]){
                   [self startV3UserInfo] ;
                }
            }
                break ;
                
           case ServiceRequestTypeTestUrl:
            {
                resultSendData = ConvertToClassPointer(NSDictionary, dataObject) ;
            }
                break ;
              
           case ServiceRequestTypeV3HomeInfo:
            {
                resultSendData = [[RH_HomePageModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
                
                if (response.statusCode==607){
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        showAlertView(@"站点维护", nil) ;
                        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:@"607",@"textOne",nil];
                        //创建通知
                        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                        return ;
                    });
                }else if (response.statusCode==605){
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        showAlertView(@"ip被限制", nil) ;
                        No_AccessView *accessView = [[No_AccessView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                        [[UIApplication sharedApplication].keyWindow addSubview:accessView];
                        return ;
                    });
                   
                }
            }
                break ;
           
           case ServiceRequestTypeV3UserInfo:
            {
                resultSendData = [[RH_UserGroupInfoModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
                
                RH_UserGroupInfoModel *userGroupModel = ConvertToClassPointer(RH_UserGroupInfoModel, resultSendData) ;
                if (userGroupModel){
                    RH_UserInfoManager *userInfoManager = [RH_UserInfoManager shareUserManager] ;
                    [userInfoManager setMineSettingInfo:userGroupModel.mUserSetting] ;
                    [userInfoManager setBankList:userGroupModel.mBankList] ;
                }
                [self startV3GetUserAssertInfo] ;
            }
                break ;
            
            case ServiceRequestTypeV3APIGameList:
            {
                NSArray *tmpArray = [RH_LotteryInfoModel dataArrayWithInfoArray:[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] arrayValueForKey:RH_GP_APIGAMELIST_LIST]] ;
                NSInteger total = [[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]
                                     dictionaryValueForKey:@"page"]  integerValueForKey:RH_GP_APIGAMELIST_TOTALCOUNT]   ;
                
                resultSendData = @{RH_GP_APIGAMELIST_LIST:tmpArray?:@[],
                                   RH_GP_APIGAMELIST_TOTALCOUNT:@(total)
                                   } ;
            }
                break ;
            
            case ServiceRequestTypeV3BettingList:
            {
                NSArray *tmpArray = [RH_BettingInfoModel dataArrayWithInfoArray:[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] arrayValueForKey:RH_GP_BETTINGLIST_LIST]] ;
                NSInteger total = [[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] integerValueForKey:RH_GP_BETTINGLIST_TOTALCOUNT]   ;
                
                NSDictionary *statisticsDataDict = [[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] dictionaryValueForKey:RH_GP_BETTINGLIST_STATISTICSDATA] ;
                resultSendData = @{RH_GP_BETTINGLIST_LIST:tmpArray?:@[],
                                   RH_GP_BETTINGLIST_TOTALCOUNT:@(total),
                                   RH_GP_BETTINGLIST_STATISTICSDATA:statisticsDataDict?:@{}
                                   } ;
            }
                break ;
            
            case ServiceRequestTypeV3DepositList:
            {
                resultSendData = [[RH_CapitalInfoOverviewModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
            }
                break ;
                
            case ServiceRequestTypeV3UserSafeInfo:
            {
                resultSendData = [[RH_UserSafetyCodeModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
                
                RH_UserSafetyCodeModel *userSafetyCodeModel = ConvertToClassPointer(RH_UserSafetyCodeModel, resultSendData) ;
                if (userSafetyCodeModel){
                    RH_UserInfoManager *userInfoManager = [RH_UserInfoManager shareUserManager] ;
                    [userInfoManager setUserSafetyInfo:userSafetyCodeModel] ;
                }
            }
                break;
                
            case ServiceRequestTypeV3UpdateSafePassword:
            {
                resultSendData = [[RH_UserSafetyCodeModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
                
                if (resultSendData){
                    RH_UserInfoManager *userInfoManager = [RH_UserInfoManager shareUserManager] ;
                    [userInfoManager setUserSafetyInfo:resultSendData] ;
                }
            }
                break ;
                
                case ServiceRequestTypeV3ActivityStatus:
            {
                resultSendData = [[RH_ActivityStatusModel alloc]initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject)dictionaryValueForKey:RH_GP_V3_DATA]];
            }
                break;
                case ServiceRequestTypeV3OpenActivity:
            {
                resultSendData = [[RH_OpenActivityModel alloc]initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject)dictionaryValueForKey:RH_GP_V3_DATA]];
            }
                break;
            case ServiceRequestTypeV3BettingDetails:
            {
                resultSendData = [[RH_BettingDetailModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
            }
                break ;

            case ServiceRequestTypeV3DepositListDetails:
            {
               resultSendData = [[RH_CapitalDetailModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
            }
                break ;
            case ServiceRequestTypeV3DepositPullDownList:
            {
                resultSendData = [RH_CapitalTypeModel dataArrayWithDictInfo:[ConvertToClassPointer(NSDictionary, dataObject)dictionaryValueForKey:RH_GP_V3_DATA]];
            }
                break ;
                
           case ServiceRequestTypeV3PromoList:
            {
                NSArray *list = [RH_PromoInfoModel dataArrayWithInfoArray:[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] arrayValueForKey:RH_GP_PROMOLIST_LIST]] ;
                NSInteger total = [[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]
                                     integerValueForKey:RH_GP_PROMOLIST_TOTALCOUNT]   ;
                
                resultSendData = @{RH_GP_PROMOLIST_LIST:list?:@[],
                                   RH_GP_PROMOLIST_TOTALCOUNT:@(total)
                                   } ;
            }
                break ;
                
            case ServiceRequestTypeV3SystemNotice:
            {
                NSArray *tmpArray = [RH_SystemNoticeModel dataArrayWithInfoArray:[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] arrayValueForKey:RH_GP_SYSTEMNOTICE_LIST]] ;
                NSInteger total = [[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]
                                      integerValueForKey:RH_GP_SYSTEMNOTICE_TOTALNUM]   ;
                resultSendData = @{RH_GP_SYSTEMNOTICE_LIST:tmpArray?:@[],
                                   RH_GP_SYSTEMNOTICE_TOTALNUM:@(total)
                                   } ;
                
            }
                break;
                
            case ServiceRequestTypeV3SystemNoticeDetail:
            {
                resultSendData = [[RH_SystemNoticeDetailModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
            }
                break;
            case ServiceRequestTypeV3GameNotice:
            {
                resultSendData = [[RH_GameNoticeModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
                
            }
                break;
                case ServiceRequestTypeV3SystemMessageYes:
            {
              
                
            }
                break;
            case ServiceRequestTypeV3GameNoticeDetail:
            {
                resultSendData = [[RH_GameNoticeDetailModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
            }
                break;
                
            case ServiceRequestTypeV3OneStepRecory:
            {
                resultSendData = ConvertToClassPointer(NSDictionary, dataObject) ;
                [self startV3UserInfo] ;
            }
                break;
                
            case ServiceRequestTypeV3AddBitCoin:
            {
                resultSendData = [[RH_BitCodeModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
                
                if (resultSendData){
                    RH_UserInfoManager *userInfoManager = [RH_UserInfoManager shareUserManager] ;
                    [userInfoManager.mineSettingInfo updateBitCode:ConvertToClassPointer(RH_BitCodeModel, resultSendData)] ;
                }
            }
                break;
                
            case ServiceRequestTypeV3SiteMessage:
            {
                NSArray *tmpArray = [RH_SiteMessageModel dataArrayWithInfoArray:[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] arrayValueForKey:RH_GP_SYSTEMNOTICE_LIST]] ;
                NSInteger total = [[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]
                                   integerValueForKey:RH_GP_SITEMESSAGE_PAGETOTALNUM]   ;
                resultSendData = @{RH_GP_SYSTEMNOTICE_LIST:tmpArray?:@[],
                                   RH_GP_SYSTEMNOTICE_TOTALNUM:@(total)
                                   } ;
            }
                break;
            case ServiceRequestTypeV3SiteMessageMyMessage:
            {
                NSArray *tmpArray = [RH_SiteMyMessageModel dataArrayWithInfoArray:[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] arrayValueForKey:@"dataList"]];
                NSInteger total = [[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]
                                   integerValueForKey:@"total"]   ;
                resultSendData = @{@"dataList":tmpArray?:@[],
                                   RH_GP_SYSTEMNOTICE_TOTALNUM:@(total)
                                   } ;
            }
                break;
                
            case ServiceRequestTypeV3PromoActivityType:
            {
                NSArray *orginDataArr = [ConvertToClassPointer(NSDictionary, dataObject) arrayValueForKey:RH_GP_V3_DATA] ;
                NSMutableArray *dataArr = [NSMutableArray array] ;
                [dataArr insertObject:@{@"activityKey":@"all",@"activityTypeName":@"全部"} atIndex:0];
                [dataArr addObjectsFromArray:orginDataArr];
                NSArray *dataArr1 = [dataArr copy] ;
                resultSendData =[RH_DiscountActivityTypeModel dataArrayWithInfoArray:dataArr1] ;
            }
                break;
                
            case ServiceRequestTypeV3ActivityDetailList:
            {
                resultSendData = [RH_DiscountActivityModel dataArrayWithInfoArray:[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] arrayValueForKey:RH_GP_ACTIVITYDATALIST_LIST]] ;
                
            }
                break;
            case ServiceRequestTypeV3AddApplyDiscountsVerify:
            {
                resultSendData =[[RH_SendMessageVerityModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
            }
                break;
                case ServiceRequestTypeV3AddApplyDiscounts:
            {
                
                resultSendData =ConvertToClassPointer(NSDictionary, dataObject);
                
            }
                break;
            case ServiceRequestTypeV3SiteMessageMyMessageDetail:
            {
                resultSendData = [RH_SiteMyMessageDetailModel dataArrayWithInfoArray:[ConvertToClassPointer(NSDictionary, dataObject)arrayValueForKey:RH_GP_V3_DATA]];
            }
                break;
            
            case ServiceRequestTypeV3MyMessageMyMessageReadYes:
            {
                
            }
                break;
                
             case ServiceRequestTypeV3SiteMessageDetail:
            {
                resultSendData =[[RH_SiteMsgSysMsgModel alloc]initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
            }
                break;
            case ServiceRequestTypeV3GameLink:
            case ServiceRequestTypeV3GameLinkForCheery:
            {
                resultSendData =[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] ;
            }
                break ;
                
            case ServiceRequestTypeV3UserLoginOut:
            {
                [self.appDelegate updateLoginStatus:NO] ;
            }
                break ;
                
            case ServiceRequestTypeV3GetWithDrawInfo:
            {
                
                resultSendData = [[RH_WithDrawModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
            }
                break;
            
           case ServiceRequestTypeV3AddBankCard:
            {
                resultSendData = [[RH_BankCardModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
                
                if (resultSendData){
                    RH_UserInfoManager *userInfoManager = [RH_UserInfoManager shareUserManager] ;
                    [userInfoManager.mineSettingInfo updateBankCard:ConvertToClassPointer(RH_BankCardModel, resultSendData)] ;
                }
                
            }
                break ;
            case ServiceRequestTypeV3LoadGameType:
            {
                  resultSendData = ConvertToClassPointer(NSArray, [dataObject objectForKey:RH_GP_V3_DATA]) ;
            }
                break;
            case ServiceRequestTypeV3SafetyPasswordAutuentification:
            {
                 resultSendData =ConvertToClassPointer(NSDictionary, dataObject);
            }
                break;
            
            case ServiceRequestTypeWithDrawFee:
            {
                resultSendData = [[AuditMapModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA])] ;
            }
                break ;
           
            case ServiceRequestTypeTimeZoneInfo:
            {
                resultSendData = [ConvertToClassPointer(NSDictionary, dataObject) stringValueForKey:RH_GP_V3_DATA] ;
                
                if (resultSendData){
                    RH_UserInfoManager *userInfoManager = [RH_UserInfoManager shareUserManager] ;
                    [userInfoManager updateTimeZone:resultSendData] ;
                }
            }
                break ;
                
                case ServiceRequestTypeSiteMessageUnReadCount:
            {
                resultSendData = [[RH_SiteMsgUnReadCountModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA])] ;
            }
                break ;
                
                case ServiceRequestTypeV3SharePlayerRecommend:   //分享
            {
              resultSendData = [[RH_SharePlayerRecommendModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA])] ;
            }
                break ;
                
            case ServiceRequestTypeV3VerifyRealNameForApp:  // 验证老用户登录
            {
                 resultSendData =ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA]);
            }
                break ;
            case ServiceRequestTypeV3GETUSERASSERT:
            {
                resultSendData = [ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] ;
//                if (MineSettingInfo){
//                    [MineSettingInfo updateUserBalanceInfo:ConvertToClassPointer(NSDictionary, resultSendData)] ;
//                }
                  [MineSettingInfo updateUserBalanceInfo:ConvertToClassPointer(NSDictionary, resultSendData)] ;
            }
                break;
            case ServiceRequestTypeV3RefreshSession:
            {
                resultSendData =ConvertToClassPointer(NSDictionary, dataObject);
            }
                break ;
                case ServiceRequestTypeV3IsOpenCodeVerifty:
            {
                resultSendData =ConvertToClassPointer(NSDictionary, dataObject);
            }
                break ;
            case ServiceRequestTypeV3DepositeOrigin:
            {
//                resultSendData = [[RH_DepositeTransferModel alloc]initWithInfoDic:ConvertToClassPointer(NSArray, [dataObject objectForKey:RH_GP_V3_DATA])];
                resultSendData = [RH_DepositeTransferModel dataArrayWithInfoArray:ConvertToClassPointer(NSArray, [dataObject objectForKey:RH_GP_V3_DATA])];
                
                
                
            }
                break;
            case ServiceRequestTypeV3RegiestInit:
            {
                NSLog(@"%@", dataObject);
                resultSendData = [[RH_RegisetInitModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA])] ;
            }
                break ;
            case ServiceRequestTypeV3AboutUs:
            {
                resultSendData = [[RH_AboutUsModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA])] ;
            }
                break;
            case ServiceRequestTypeV3RegiestTerm:
            {
                 resultSendData = [[RH_RegisterClauseModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA])] ;
            }
                break ;
            case ServiceRequestTypeV3FirstHelpFirstTyp:
            {
                 resultSendData = ConvertToClassPointer(NSArray, [dataObject objectForKey:RH_GP_V3_DATA]) ;
                resultSendData = [RH_HelpCenterModel dataArrayWithInfoArray:resultSendData] ;
                
            }
                break ;
            case ServiceRequestTypeV3FirstHelpSecondTyp:
            {
                resultSendData = ConvertToClassPointer(NSArray, [[dataObject objectForKey:RH_GP_V3_DATA] objectForKey:@"list"]) ;
                resultSendData = [RH_HelpCenterSecondModel dataArrayWithInfoArray:resultSendData] ;
            }
                break ;
            case ServiceRequestTypeV3HelpDetail:
            {
                resultSendData = ConvertToClassPointer(NSArray, [[dataObject objectForKey:RH_GP_V3_DATA] objectForKey:@"list"]) ;
                //增加特殊字符转义
                for (NSDictionary *resultDic in resultSendData) {
                    NSString *helpContent = [resultDic objectForKey:@"helpContent"];
                    helpContent = [helpContent stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                    helpContent = [helpContent stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                    [resultDic setValue:helpContent forKey:@"helpContent"];
                }
                resultSendData = [RH_HelpCenterDetailModel dataArrayWithInfoArray:resultSendData] ;

            }
                break ;
                case ServiceRequestTypeV3DepositOriginSeachSale:
            {
                resultSendData = [[RH_DepositOriginseachSaleModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA])] ;
            }
                break;
                case ServiceRequestTypeV3DepositOriginBittionSeachSale:
            {
                resultSendData = [[RH_DepositOriginseachSaleModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA])] ;
            }
                break;
            case ServiceRequestTypeV3GetNoAutoTransferInfo:
            {
                resultSendData = [[RH_GetNoAutoTransferInfoModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA])] ;
            }
                break ;
                case ServiceRequestTypeV3OnlinePay:
            {
                
            }
//                break;
//            case ServiceRequestTypeV3CompanyPay:{
//
//            }
//                break;
//                case ServiceRequestTypeV3CounterPay:
//            {
//
//            }
//                break;
//                case ServiceRequestTypeV3ElectronicPay:
//            {
//                
//            }
//                break;
//                case ServiceRequestTypeV3AlipayElectronicPay:
//            {
//                
//            }
//                break;
//                case ServiceRequestTypeV3BitcoinPay:
//            {
//                
//            }
//                break;
            case ServiceRequestTypeV3OneStepRefresh:
            {
                NSDictionary *dic = [dataObject objectForKey:RH_GP_V3_DATA] ;
                resultSendData = [RH_UserApiBalanceModel dataArrayWithInfoArray:[dic objectForKey:@"apis"]] ;
            }
                break;
            case ServiceRequestTypeV3RefreshApi:
            {
                resultSendData =  [[RH_UserApiBalanceModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA])] ;
                ConvertToClassPointer(RH_UserApiBalanceModel ,resultSendData) ;
                RH_UserInfoManager *userInfoManager = [RH_UserInfoManager shareUserManager] ;
                NSArray *daraArr =userInfoManager.mineSettingInfo.mApisBalanceList;
                for (RH_UserApiBalanceModel *model in daraArr) {
                     [model upApiMoneyWith:resultSendData] ;
                }
            }
                break ;
                case ServiceRequestTypeV3DepositeOriginChannel:
            {
                resultSendData =  [[RH_DepositeTransferChannelModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA])] ;
                
            }
                break;
                case ServiceRequestTypeV3SharePlayerRecord:
            {
                resultSendData =  [[RH_ShareRecordModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA])] ;
            }
                break;
            case ServiceRequestTypeV3INITAD:
            {
                resultSendData =  [[RH_InitAdModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, [dataObject objectForKey:RH_GP_V3_DATA])] ;
            }
                break;
                
//                case ServiceRequestTypeV3ScanPay:
//            {
//                
//            }
//                break;
                case ServiceRequestTypeV3FindUserPhone:
            {
                
            }
                break;
            default:
                resultSendData = dataObject ;
                break;
        }

        *reslutData = resultSendData;
    }else{
        switch (type) {
            case ServiceRequestTypeV3UpdateSafePassword:
            {
                RH_UserSafetyCodeModel *userSafetyCode = [[RH_UserSafetyCodeModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
                
                if (userSafetyCode){
                    RH_UserInfoManager *userInfoManager = [RH_UserInfoManager shareUserManager] ;
                    [userInfoManager setUserSafetyInfo:userSafetyCode] ;
                }
            }
                break;
            
            case ServiceRequestTypeTimeZoneInfo:
            {
                //重新请求
                [self performSelector:@selector(startV3SiteTimezone) withObject:self afterDelay:3.0f] ;
            }
                break ;
                
            case ServiceRequestTypeV3UserInfo:
            {
                if (tempError.code==RH_API_ERRORCODE_USER_LOGOUT ||
                    tempError.code==RH_API_ERRORCODE_SESSION_EXPIRED){
                    [self.appDelegate updateLoginStatus:FALSE] ;
                }else{
                    [self startV3UserInfo] ;
                }
            }
                break ;
                
                case ServiceRequestTypeV3RefreshSession:
            {
                if (tempError.code==RH_API_ERRORCODE_USER_LOGOUT ||
                    tempError.code==RH_API_ERRORCODE_SESSION_EXPIRED){
                    [self.appDelegate updateLoginStatus:FALSE] ;
                }
                if (tempError.code == RH_API_ERRORCODE_SESSION_TAKEOUT) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         showAlertView(tempError.userInfo[@"NSLocalizedDescription"], nil) ;
                    }) ;
                    [self.appDelegate updateLoginStatus:FALSE] ;
                }
            }
                break ;
                case ServiceRequestTypeUserLogin:
            {
                
            }
                break ;
                
            default:
                break;
        }
    }

    return YES;
}

- (void)httpRequest:(id<CLHTTPRequestProtocol>)request response:(NSHTTPURLResponse *)response didFailedRequestWithError:(NSError *)error
{
    //by shin
    RH_ServiceRequestContext * context = [request context];

//    //此处收集域名 check fail 信息
//    if (context.serivceType==ServiceRequestTypeDomainCheck){
//        NSString *checkDomainStr = ConvertToClassPointer(NSString, [self contextForType:ServiceRequestTypeDomainCheck]) ;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *errorCode = [NSString stringWithFormat:@"%ld",error.code] ;
//            NSString *errorMessage = [error.localizedDescription copy] ;
//            NSLog(@"errorMessage==%@",errorMessage);
//            [[RH_UserInfoManager shareUserManager].domainCheckErrorList addObject:@{RH_SP_COLLECTAPPERROR_DOMAIN:checkDomainStr?:@"",
//                                                                                    RH_SP_COLLECTAPPERROR_CODE:errorCode,
//                                                                                    RH_SP_COLLECTAPPERROR_ERRORMESSAGE:errorMessage,
//                                                                                    }] ;
//            //通知告诉splashViewController ,你特么没check成功，换下一个域名在check
//            // 1.创建通知打开通知
//            NSNotification *notificationClose =[NSNotification notificationWithName:@"youAreNotCheckSuccess" object:nil userInfo:nil];
//            // 2.通过 通知中心 发送 通知
//            [[NSNotificationCenter defaultCenter] postNotification:notificationClose];
//        });
//    }

    //移除标记
    [self.httpRequests removeObjectForKey:@(context.serivceType)];
    [self.requestingMarks removeObjectForKey:@(context.serivceType)];

    //发送通知
    [self _sendFailMsgWithError:error
                    serviceType:context.serivceType
                      scopeType:context.scopeType];
}

- (void)_sendFailMsgWithError:(NSError *)error
                  serviceType:(ServiceRequestType)serviceType
                    scopeType:(ServiceScopeType)scopeType
{
    //发消息给代理
    id<RH_ServiceRequestDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(serviceRequest:serviceType:didFailRequestWithError:)){
        [delegate serviceRequest:self serviceType:serviceType didFailRequestWithError:error];
    }

    //block回调
    if (self.failBlock) {
        self.failBlock(self, serviceType, error);
    }
    if (serviceType==ServiceRequestTypeV3HomeInfo) {
        
    }
    //特点  error 信息，统一处理 。
    // error.code==RH_API_ERRORCODE_USER_LOGOUT ||
    if (( error.code==RH_API_ERRORCODE_SESSION_EXPIRED ||
          error.code==RH_API_ERRORCODE_USER_LOGOUT) &&
        serviceType!=ServiceRequestTypeV3UserLoginOut &&
        serviceType!=ServiceRequestTypeV3HomeInfo &&
        serviceType!=ServiceRequestTypeV3UserInfo &&
        serviceType!=ServiceRequestTypeV3RefreshSession &&
        serviceType!=ServiceRequestTypeSiteMessageUnReadCount&&
        serviceType!=ServiceRequestTypeV3GETUSERASSERT)
    {
        //session 过期 ,用户未登录
        ifRespondsSelector(self.delegate, @selector(serviceRequest:serviceType:SpecifiedError:)){
            [self.delegate serviceRequest:self serviceType:serviceType SpecifiedError:error] ;
        }
    }
    
    //移除上下文
    [self removeContextForType:serviceType];
}

- (void)httpRequest:(id<CLHTTPRequestProtocol>)request didSuccessRequestWithResultData:(id)reslutData
{
    RH_ServiceRequestContext * context = [request context];

    //移除请求及标记
    [self.httpRequests removeObjectForKey:@(context.serivceType)];
    [self.requestingMarks removeObjectForKey:@(context.serivceType)];

    //发送成功通知
    [self _sendSuccessMsgWithData:reslutData type:context.serivceType];
}

- (void)_sendSuccessMsgWithData:(id)data type:(ServiceRequestType)type
{
    //发消息给代理
    id<RH_ServiceRequestDelegate> delegate = self.delegate;
    ifRespondsSelector(delegate, @selector(serviceRequest:serviceType:didSuccessRequestWithData:)) {
        [delegate serviceRequest:self serviceType:type didSuccessRequestWithData:data];
    }

    //block回调
    if (self.successBlock) {
        self.successBlock(self, type, data);
    }

    //移除上下文
    [self removeContextForType:type];
}

@end
