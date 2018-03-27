//
//  RH_AboutUsModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BasicModel.h"

@interface RH_AboutUsModel : RH_BasicModel

@property(nonatomic,strong,readonly)NSString *mTitle ;
@property(nonatomic,strong,readonly)NSString *mContent ;
@property(nonatomic,strong,readonly)NSString *mContentDefault ;
@end
