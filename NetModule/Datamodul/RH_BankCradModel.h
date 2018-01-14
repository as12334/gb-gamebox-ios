//
//  RH_BankCradModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/11.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface DataModel :RH_BasicModel
@property (nonatomic,strong,readonly) NSString * mValue;
@property (nonatomic,strong,readonly) NSString * mText;

@end

@interface RH_BankCradModel :RH_BasicModel
@property (nonatomic,strong,readonly) NSArray<DataModel *>  *mData;
@property(nonatomic,assign,readonly)NSInteger mCode;
@property(nonatomic,assign,readonly)NSInteger mError;
@property(nonatomic,strong,readonly)NSString  *mMsg;
@property(nonatomic,strong,readonly)NSString *mVersion;

@end


