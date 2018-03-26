//
//  RH_RegisetInitModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_RegisetInitModel.h"
#import "coreLib.h"
#import "RH_API.h"

@implementation RH_RegisetInitModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _paramsModel = [[ParamsModel alloc] initWithInfoDic:[info objectForKey:@"params"]];
        _signUpDataMapModel = [info objectForKey:@"signUpDataMap"] ;
        _requiredJson =  [info objectForKey:@"requiredJson"] ;
        _isPhone = [info boolValueForKey:@"isPhone"] ;
        _isRequiredForRegisterCode = [info boolValueForKey:@"isRequiredForRegisterCode"] ;
        _isEmail = [info boolValueForKey:@"isEmail"] ;
        _selectOptionModel = [info objectForKey:@"selectOption"] ;
        _registCodeField = [info boolValueForKey:@"registCodeField"] ;
        _fieldModel = [FieldModel dataArrayWithInfoArray:[info objectForKey:@"field"]] ;
    }
    return self ;
}
@end


@implementation IpLocaleModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _region = [info stringValueForKey:@"region"] ;
        _country = [info stringValueForKey:@"country"] ;
        _city = [info stringValueForKey:@"city"] ;
    }
    return self ;
}
@end

@implementation ParamsModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _minDate = [info integerValueForKey:@"minDate"] ;
        _ipLocaleModel = [[IpLocaleModel alloc] initWithInfoDic:[info objectForKey:@"ipLocale"]];
        _timezone = [info stringValueForKey:@"timezone"] ;
        _registCode = [info stringValueForKey:@"registCode"] ;
        _currency = [info stringValueForKey:@"currency"] ;
        _maxDate =  [info integerValueForKey:@"maxDate"] ;
    }
    return self ;
}
@end

@implementation SignUpDataMapModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _realName = [info stringValueForKey:@"realName"] ;
        _sex = [info stringValueForKey:@"sex"] ;
        _m110 = [info stringValueForKey:@"110"] ;
        _defaultLocale = [info stringValueForKey:@"defaultLocale"] ;
        _m201 = [info stringValueForKey:@"201"] ;
        _paymentPassword = [info stringValueForKey:@"paymentPassword"] ;
        _birthday = [info stringValueForKey:@"birthday"] ;
        _defaultTimezone = [info stringValueForKey:@"defaultTimezone"] ;
        _password = [info stringValueForKey:@"password"] ;
        _mainCurrency = [info stringValueForKey:@"mainCurrency"] ;
        _securityIssues = [info stringValueForKey:@"securityIssues"] ;
        _m301 = [info stringValueForKey:@"301"] ;
        _username = [info stringValueForKey:@"username"] ;
        _m304 = [info stringValueForKey:@"304"] ;
    }
    return self ;
}
@end

@implementation FieldModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _isRequired = [info stringValueForKey:@"isRequired"] ;
        _status = [info stringValueForKey:@"status"] ;
        _isRegField = [info stringValueForKey:@"isRegField"] ;
        _mId = [info integerValueForKey:@"id"] ;
        _sort = [info integerValueForKey:@"sort"] ;
        _derail = [info boolValueForKey:@"derail"] ;
        _bulitIn = [info boolValueForKey:@"bulitIn"] ;
        _isOnly = [info stringValueForKey:@"isOnly"] ;
        _i18nName = [info stringValueForKey:@"i18nName"] ;
        _name = [info stringValueForKey:@"name"] ;
    }
    return self ;
}
@end

@implementation SexModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mValue = [info stringValueForKey:@"Value"] ;
        _mText = [info stringValueForKey:@"Text"] ;
    }
    return self ;
}
@end

@implementation DefaultLocaleModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mValue = [info stringValueForKey:@"Value"] ;
        _mText = [info stringValueForKey:@"Text"] ;
    }
    return self ;
}
@end

@implementation MainCurrencyModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mValue = [info stringValueForKey:@"Value"] ;
        _mText = [info stringValueForKey:@"Text"] ;
    }
    return self ;
}
@end

@implementation SecurityIssuesModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _mValue = [info stringValueForKey:@"Value"] ;
        _mText = [info stringValueForKey:@"Text"] ;
    }
    return self ;
}
@end

@implementation SelectOptionModel
-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info]) {
        _sexModel = [SexModel dataArrayWithInfoArray:[info objectForKey:@"sex"]] ;
        _defaultLocaleModel = [DefaultLocaleModel dataArrayWithInfoArray:[info objectForKey:@"defaultLocale"]] ;
        _mainCurrencyModel = [MainCurrencyModel dataArrayWithInfoArray:[info objectForKey:@"mainCurrency"]] ;
        _securityIssuesModel = [SecurityIssuesModel dataArrayWithInfoArray:[info objectForKey:@"securityIssues"]] ;
    }
    return self ;
}
@end

