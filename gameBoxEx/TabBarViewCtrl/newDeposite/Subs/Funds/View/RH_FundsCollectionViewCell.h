//
//  RH_FundsCollectionViewCell.h
//  gameBoxEx
//
//  Created by jun on 2018/9/28.
//  Copyright © 2018 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_UserApiBalanceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RH_FundsCollectionViewCell : UICollectionViewCell
-(void)updateUIWithModel:(RH_UserApiBalanceModel *)model;
@end

NS_ASSUME_NONNULL_END
