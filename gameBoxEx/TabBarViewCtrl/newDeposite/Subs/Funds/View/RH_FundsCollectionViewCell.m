//
//  RH_FundsCollectionViewCell.m
//  gameBoxEx
//
//  Created by jun on 2018/9/28.
//  Copyright © 2018 luis. All rights reserved.
//

#import "RH_FundsCollectionViewCell.h"

@interface RH_FundsCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;

@end
@implementation RH_FundsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateUIWithModel:(RH_UserApiBalanceModel *)model{
    self.nameLab.text = model.mApiName ;
    
    if (![model.mStatus isEqualToString:@""]) {
        self.balanceLab.text = model.mStatus ;
    }else
    {
        self.balanceLab.text = [NSString stringWithFormat:@"%.2f",model.mBalance] ;
    }
}
@end
