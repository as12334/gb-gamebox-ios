//
//  RH_DepositeSystemPlatformCell.h
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "CLTableViewCell.h"
#import "RH_DepositeSystemPlatformCell.h"
@class RH_DepositeSystemPlatformCell;
@protocol DepositeSystemPlatformCellDelegate<NSObject>
@optional
-(void)depositeSystemPlatformCellDidtouch:(RH_DepositeSystemPlatformCell*)cell payTypeString:(NSString *)payType accountModel:(id)accountModel;
@end
@interface RH_DepositeSystemPlatformCell : CLTableViewCell
@property(nonatomic,weak)id<DepositeSystemPlatformCellDelegate>delegate;
-(void)updateConllectionView;
@end
