//
//  RH_DiscountActivityModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DiscountActivityModel.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_APPDelegate.h"

@implementation RH_DiscountActivityModel
@synthesize showLink = _showLink ;
@synthesize showPhoto = _showPhoto ;
@synthesize showImageSize = _showImageSize ;

-(id)initWithInfoDic:(NSDictionary *)info
{
    if (self = [super initWithInfoDic:info])
    {
        _mPhoto = [info stringValueForKey:RH_GP_DISCOUNTACTIVITY_PHOTO];
        _mUrl = [info stringValueForKey:RH_GP_DISCOUNTACTIVITY_URL];
    }
    return self;
}


///----
-(NSString *)showPhoto
{
    if (!_showPhoto){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        _showPhoto = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mPhoto] ;
    }
    
    return _showPhoto ;
}

-(NSString *)showLink
{
    if (!_showLink){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        _showLink = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mUrl] ;
    }
    
    return _showLink ;
}

-(CGSize)showImageSize
{
    if (CGSizeEqualToSize(CGSizeZero, _showImageSize)){
        _showImageSize = CGSizeMake(426.0f,282.0f) ;
    }
    
    return _showImageSize ;
}

-(void)updateImageSize:(CGSize)size
{
    _showImageSize = size ;
    [[NSNotificationCenter defaultCenter] postNotificationName:RHNT_DiscountActivityImageSizeChanged object:self] ;
}

@end
