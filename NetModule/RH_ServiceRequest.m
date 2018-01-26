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
#import "RH_UserBalanceGroupModel.h"
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

//----------------------------------------------------------
//访问权限
typedef NS_ENUM(NSInteger,ServiceScopeType) {
    //公开
    ServiceScopeTypePublic,
};

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
-(void)startReqDomainList
{
    [self _startServiceWithAPIName:RH_API_MAIN_URL
                        pathFormat:@"app/line.html"
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:@{RH_SP_COMMON_SITECODE:CODE,
                                     RH_SP_COMMON_SITESEC:S}
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeDomainList
                         scopeType:ServiceScopeTypePublic];
}

-(void)startCheckDomain:(NSString*)doMain
{
    [self _startServiceWithAPIName:nil
                        pathFormat:@"http://%@/__check"
                     pathArguments:@[doMain?:@""]
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeDomainCheck
                         scopeType:ServiceScopeTypePublic];
}

-(void)startUpdateCheck
{
    [self _startServiceWithAPIName:RH_API_MAIN_URL
                        pathFormat:@"app/update.html"
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:@{RH_SP_COMMON_OSTYPE:@"ios",
                                     RH_SP_COMMON_CHECKVERSION:RH_APP_UPDATECHECK
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypeGet
                       serviceType:ServiceRequestTypeUpdateCheck
                         scopeType:ServiceScopeTypePublic];
}

-(void)startLoginWithUserName:(NSString*)userName Password:(NSString*)password VerifyCode:(NSString*)verCode
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_LOGIN
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":@"app_ios, iPhone"
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

-(void)startAutoLoginWithUserName:(NSString*)userName Password:(NSString*)password
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_AUTOLOGIN
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":@"app_ios, iPhone"
                                     }
                    queryArguments:@{@"username":userName?:@"",
                                     @"password":password?:@""
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeUserAutoLogin
                         scopeType:ServiceScopeTypePublic];
}

-(void)startGetVerifyCode
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_VERIFYCODE
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":@"app_ios, iPhone"
                                     }
                    queryArguments:@{@"_t":timeStr}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeObtainVerifyCode
                         scopeType:ServiceScopeTypePublic];
}

-(void)startDemoLogin
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_DEMOLOGIN
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":@"app_ios, iPhone"
                                     }
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeDemoLogin
                         scopeType:ServiceScopeTypePublic];
}

-(void)startGetCustomService
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_GETCUSTOMPATH
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:@{RH_SP_APIRETRIVE_APIID:@(apiID)}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeAPIRetrive
                         scopeType:ServiceScopeTypePublic];
}

-(void)startUploadAPPErrorMessge:(NSDictionary*)errorDict
{
    [self _startServiceWithAPIName:RH_API_MAIN_URL
                        pathFormat:RH_API_NAME_COLLECTAPPERROR
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
        [dictTmp setValue:tagID forKey:RH_SP_APIGAMELIST_TAGID] ;
    }
    
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_APIGAMELIST
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:dictTmp
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3APIGameList
                         scopeType:ServiceScopeTypePublic];
}

-(void)startV3BettingList:(NSString*)startDate EndDate:(NSString*)endDate
               PageNumber:(NSInteger)pageNumber
                 PageSize:(NSInteger)pageSize
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_BETTINGLIST
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:@{RH_SP_BETTINGLIST_STARTDATE:startDate?:@"",
                                     RH_SP_BETTINGLIST_ENDDATE:endDate?:@""
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3BettingList
                         scopeType:ServiceScopeTypePublic];
}

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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:startTime?:@"" forKey:RH_SP_SYSTEMNOTICE_STARTTIME];
    [dict setValue:endTime?:@"" forKey:RH_SP_SYSTEMNOTICE_ENDTIME];
    [dict setValue:@(pageNumber) forKey:RH_SP_SYSTEMNOTICE_PAGENUMBER];
    [dict setValue:@(pageSize) forKey:RH_SP_SYSTEMNOTICE_PAGESIZE];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SYSTEMNOTICE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_GAMENOTICE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3GameNoticeDetail
                         scopeType:ServiceScopeTypePublic];
    
}

-(void)startV3GetSafetyVerifyCode
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SAFETYCAPCHA
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":@"app_ios, iPhone"
                                     }
                    queryArguments:@{@"_t":timeStr}
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SafetyObtainVerifyCode
                         scopeType:ServiceScopeTypePublic];
}

-(void)startV3PromoList:(NSInteger)pageNumber
               PageSize:(NSInteger)pageSize
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_PROMOLIST
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":@"app_ios, iPhone"
                                     }
                    queryArguments:@{RH_SP_PROMOLIST_PAGENUMBER:@(pageNumber),
                                     RH_SP_PROMOLIST_PAGESIZE:@(pageSize)
                                     }
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3PromoList
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark - 一键回收
-(void)startV3OneStepRecovery
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ONESTEPRECOVERY
                     pathArguments:nil
                   headerArguments:@{@"X-Requested-With":@"XMLHttpRequest",
                                     @"User-Agent":@"app_ios, iPhone"
                                     }
                    queryArguments:nil
                     bodyArguments:nil
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:@{RH_SP_ADDBTC_BANKCARDNUMBER:bitNumber?:@""}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3PromoActivityType
                         scopeType:ServiceScopeTypePublic];
}

#pragma mark - tabbar2 优惠活动主界面列表
-(void)startV3LoadDiscountActivityTypeListWithKey:(NSString *)mKey
                                       PageNumber:(NSInteger)pageNumber
                                         pageSize:(NSInteger)pageSize
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_ACTIVITYDATALIST
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:@{RH_SP_ACTIVITYDATALIST_SEARCHKEY:mKey?:@"",
                                     RH_SP_ACTIVITYDATALIST_PAGENUMBER:@(pageNumber),
                                     RH_SP_ACTIVITYDATALIST_PAGESIZE:@(pageSize)
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3GameLink
                         scopeType:ServiceScopeTypePublic];
    
}




#pragma mark - 获取取款接口
-(void)startV3GetWithDraw
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_GETWITHDRAWUSERINFO
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
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
                           gbToken:(NSString *)gbToken
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(withdrawAmount) forKey:RH_SP_SUBMITWITHDRAWINFO_WITHDRAWAMOUNT];
    [dict setObject:gbToken?:@"" forKey:RH_SP_SUBMITWITHDRAWINFO_GBTOKEN];
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_SUBMITWITHDRAWINFO
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:dict
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3SubmitWithdrawInfo
                         scopeType:ServiceScopeTypePublic];
}
#pragma mark - 获取游戏分类
-(void)startV3LoadGameType
{
    [self _startServiceWithAPIName:self.appDelegate.domain
                        pathFormat:RH_API_NAME_LOADGAMETYPE
                     pathArguments:nil
                   headerArguments:@{@"User-Agent":@"app_ios, iPhone"}
                    queryArguments:nil
                     bodyArguments:nil
                          httpType:HTTPRequestTypePost
                       serviceType:ServiceRequestTypeV3LoadGameType
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
        if ([THEME isEqualToString:@"pink.skin"]){
            [queryArgs setValue:@"blue" forKey:RH_SP_COMMON_V3_THEME] ;
        }else if ([THEME isEqualToString:@"blue.skin"]){
            [queryArgs setValue:@"blue" forKey:RH_SP_COMMON_V3_THEME] ;
        }else{
            [queryArgs setValue:@"white" forKey:RH_SP_COMMON_V3_THEME] ;
        }
        
        [queryArgs setValue:RH_SP_COMMON_V3_VERSION_VALUE forKey:RH_SP_COMMON_V3_VERSION] ;
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
    
    RH_HTTPRequest * httpRequest = [[RH_HTTPRequest alloc] initWithAPIName:apiName
                                                                pathFormat:pathFormat
                                                             pathArguments:pathArguments
                                                            queryArguments:queryArgs
                                                           headerArguments:headerArguments
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
    RH_ServiceRequestContext * context = [request context];
    ServiceRequestType type = context.serivceType;

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
        }else{
            *error = [NSError resultDataNoJSONError] ;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *checkDomainStr = ConvertToClassPointer(NSString, [self contextForType:ServiceRequestTypeDomainCheck]) ;
                NSString *errorCode = [NSString stringWithFormat:@"%d",response.statusCode] ;
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
    }else if (type == ServiceRequestTypeObtainVerifyCode ||
              type == ServiceRequestTypeV3SafetyObtainVerifyCode){
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
    }
//    else if (type==ServiceRequestTypeV3AddApplyDiscounts){
//        NSError * tempError = nil;
//        NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
//                                                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
//                                                                                      error:&tempError] : @{};
//        *reslutData = @([dataObject boolValueForKey:@"isSuccess"]) ;
//        return YES ;
//    }
    //json解析
    NSError * tempError = nil;
    NSDictionary * dataObject = [data length] ? [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                                                  error:&tempError] : @{};
    
    if (tempError) { //json解析错误
        tempError = [NSError resultErrorWithURLResponse:response]?:[NSError resultDataNoJSONError];
    }else{
        if ([SITE_TYPE isEqualToString:@"integratedv3oc"]){
            if ([dataObject integerValueForKey:RH_GP_V3_ERROR defaultValue:0]!=0) { //结果错误
                tempError = [NSError resultErrorWithResultInfo:dataObject];
            }
        }
    }
 
    if ([SITE_TYPE isEqualToString:@"integratedv3oc"] &&
        (type==ServiceRequestTypeUserLogin || type == ServiceRequestTypeUserAutoLogin)){//针对原生 ，检测http 302 错误
        if (response.statusCode==302){
            tempError = ERROR_CREATE(HTTPRequestResultErrorDomin,302,@"login fail",nil);
        }
    }
    
    if (error) {
        *error = tempError;
    }

    //结果成功，开始处理数据
    if (tempError == nil) {

        id resultSendData = nil;
        switch (type) {
            case ServiceRequestTypeDomainList:
            {
                resultSendData = ConvertToClassPointer(NSArray, dataObject) ;
            }
                break ;
                
            case ServiceRequestTypeUpdateCheck:
            {
                resultSendData = [[RH_UpdatedVersionModel alloc] initWithInfoDic:ConvertToClassPointer(NSDictionary, dataObject)] ;
            }
                break ;
              
           case ServiceRequestTypeUserLogin:
           case ServiceRequestTypeUserAutoLogin:
            {
                resultSendData = ConvertToClassPointer(NSDictionary, dataObject) ;
                
                if ([SITE_TYPE isEqualToString:@"integratedv3oc"] &&
                    [ConvertToClassPointer(NSDictionary, resultSendData) boolValueForKey:@"success" defaultValue:FALSE]){
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
            }
                break ;
           
           case ServiceRequestTypeV3UserInfo:
            {
                resultSendData = [[RH_UserGroupInfoModel alloc] initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
                
                RH_UserGroupInfoModel *userGroupModel = ConvertToClassPointer(RH_UserGroupInfoModel, resultSendData) ;
                if (userGroupModel){
                    RH_UserInfoManager *userInfoManager = [RH_UserInfoManager shareUserManager] ;
                    [userInfoManager setUserBalanceInfo:userGroupModel.mUserBalanceGroupInfo] ;
                    [userInfoManager setMineSettingInfo:userGroupModel.mUserSetting] ;
                    [userInfoManager setBankList:userGroupModel.mBankList] ;
                }
            }
                break ;
            
            case ServiceRequestTypeV3APIGameList:
            {
                NSArray *tmpArray = [RH_LotteryInfoModel dataArrayWithInfoArray:[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] arrayValueForKey:RH_GP_APIGAMELIST_LIST]] ;
                NSInteger total = [[[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]
                                     dictionaryValueForKey:@"page"] dictionaryValueForKey:@"page"] integerValueForKey:RH_GP_APIGAMELIST_TOTALCOUNT]   ;
                
                resultSendData = @{RH_GP_APIGAMELIST_LIST:tmpArray?:@[],
                                   RH_GP_APIGAMELIST_TOTALCOUNT:@(total)
                                   } ;
            }
                break ;
            
            case ServiceRequestTypeV3BettingList:
            {
                NSArray *tmpArray = [RH_BettingInfoModel dataArrayWithInfoArray:[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] arrayValueForKey:RH_GP_BETTINGLIST_LIST]] ;
                NSInteger total = [[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]
                                     dictionaryValueForKey:@"statisticsData"]  integerValueForKey:RH_GP_BETTINGLIST_TOTALCOUNT]   ;
                
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
                resultSendData = [[RH_ActivityModel alloc]initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject)dictionaryValueForKey:RH_GP_V3_DATA]];
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
                resultSendData = ConvertToClassPointer(NSArray, dataObject) ;
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
                resultSendData = [RH_SiteMyMessageModel dataArrayWithInfoArray:[ConvertToClassPointer(NSDictionary, dataObject)arrayValueForKey:RH_GP_V3_DATA]];
            }
                break;
                
            case ServiceRequestTypeV3PromoActivityType:
            {
                resultSendData =[RH_DiscountActivityTypeModel dataArrayWithInfoArray:[ConvertToClassPointer(NSDictionary, dataObject) arrayValueForKey:RH_GP_V3_DATA]] ;
            }
                break;
                
            case ServiceRequestTypeV3ActivityDetailList:
            {
                NSArray *tmpArray = [RH_DiscountActivityModel dataArrayWithInfoArray:[[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA] arrayValueForKey:RH_GP_ACTIVITYDATALIST_LIST]] ;
                NSInteger total = [[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]
                                   integerValueForKey:RH_GP_ACTIVITYDATALIST_TOTALNUMBER]   ;
                resultSendData = @{RH_GP_ACTIVITYDATALIST_LIST:tmpArray?:@[],
                                   RH_GP_ACTIVITYDATALIST_TOTALNUMBER:@(total)
                                   } ;
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
                resultSendData =[[RH_SiteMyMessageDetailModel alloc]initWithInfoDic:[ConvertToClassPointer(NSDictionary, dataObject) dictionaryValueForKey:RH_GP_V3_DATA]] ;
            }
                break;
            
            case ServiceRequestTypeV3MyMessageMyMessageReadYes:
            {
                
            }
                break;
             
            case ServiceRequestTypeV3GameLink:
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
            
            default:
                break;
        }
        
        //处理重要的 error 信息
        if (tempError.code==600){//session 过期
            [self.appDelegate updateLoginStatus:NO] ;
            showAlertView(@"提示信息", @"session已过期,请重新登入") ;
        }
    }

    return YES;
}

- (void)httpRequest:(id<CLHTTPRequestProtocol>)request response:(NSHTTPURLResponse *)response didFailedRequestWithError:(NSError *)error
{
    RH_ServiceRequestContext * context = [request context];
    
    //此处收集域名 check fail 信息
    if (context.serivceType==ServiceRequestTypeDomainCheck){
        NSString *checkDomainStr = ConvertToClassPointer(NSString, [self contextForType:ServiceRequestTypeDomainCheck]) ;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *errorCode = [NSString stringWithFormat:@"%d",error.code] ;
            NSString *errorMessage = [error.localizedDescription copy] ;
            [[RH_UserInfoManager shareUserManager].domainCheckErrorList addObject:@{RH_SP_COLLECTAPPERROR_DOMAIN:checkDomainStr?:@"",
                                                                                    RH_SP_COLLECTAPPERROR_CODE:errorCode,
                                                                                    RH_SP_COLLECTAPPERROR_ERRORMESSAGE:errorMessage,
                                                                                    }] ;
        });
    }
    
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
