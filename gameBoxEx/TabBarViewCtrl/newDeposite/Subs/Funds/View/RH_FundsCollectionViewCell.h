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

@protocol RH_FundsCollectionViewCellDelegate <NSObject>

-(void)refreshAndRecouveryByApiId:(NSString *)apiId Index:(NSInteger)index IsMaintaining:(BOOL)isMaintaining;

@end

@interface RH_FundsCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak)id<RH_FundsCollectionViewCellDelegate>delegate;
-(void)updateUIWithModel:(RH_UserApiBalanceModel *)model
               Animation:(BOOL)animation
               IndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
