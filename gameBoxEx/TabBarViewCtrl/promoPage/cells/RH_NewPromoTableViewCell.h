//
//  RH_NewPromoTableViewCell.h
//  gameBoxEx
//ga
//  Created by barca on 2018/10/1.
//  Copyright © 2018 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_DiscountActivityModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol PromoTableViewCellDelegaet <NSObject>
-(void)cellToJump:(NSIndexPath *)cellIndexPath;
@end
@interface RH_NewPromoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *promoImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *promoButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (nonatomic,strong)NSIndexPath *cellIndexPath;
@property (nonatomic,weak)id<PromoTableViewCellDelegaet>promoDelegate;
-(void)passRH_DiscountActivityModel:(RH_DiscountActivityModel *)discountActivityModel;
@end

NS_ASSUME_NONNULL_END
