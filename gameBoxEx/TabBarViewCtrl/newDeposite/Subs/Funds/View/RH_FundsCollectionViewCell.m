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
@property (weak, nonatomic) IBOutlet UIImageView *maintainImageView;

@end
@implementation RH_FundsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateUIWithModel:(RH_UserApiBalanceModel *)model{
    self.nameLab.text = model.mApiName ;
    
    if (![model.mStatus isEqualToString:@""]) {
        //维护状态
        self.balanceLab.text = model.mStatus ;
        self.maintainImageView.hidden = NO;
    }else
    {
        self.maintainImageView.hidden = YES;
         self.balanceLab.text = [NSString stringWithFormat:@"%.2f",model.mBalance] ;
    }
}
//刷新和回收哦是同一个按钮
- (IBAction)recoveryAndRefreshBtnClick:(id)sender {
    UIButton *refreshBtn = (UIButton *)sender;
    [refreshBtn setImage:[UIImage imageNamed:@"icon_recycling_orange"] forState:UIControlStateNormal];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = @(M_PI*2);
    animation.repeatCount = MAXFLOAT;
    animation.duration = 1;
    [refreshBtn.imageView.layer addAnimation:animation forKey:@"animation"];
}

@end
