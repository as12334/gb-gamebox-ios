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
@property (weak, nonatomic) IBOutlet UIButton *refreshAndRecoveryBtn;
@property(nonatomic,copy)NSString *apiId;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)RH_UserApiBalanceModel *model;
@end
@implementation RH_FundsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateUIWithModel:(RH_UserApiBalanceModel *)model
               Animation:(BOOL)animation
               IndexPath:(nonnull NSIndexPath *)indexPath{
    self.model = model;
    self.apiId = [NSString stringWithFormat:@"%ld",model.mApiID];
    self.indexPath = indexPath;
    self.nameLab.text = model.mApiName ;
    if ([model.mStatus isEqualToString:@""]) {
        self.maintainImageView.hidden = YES;
        self.balanceLab.text = [NSString stringWithFormat:@"%.2f",model.mBalance] ;
       
    }else
    {
        //维护状态
        self.balanceLab.text = model.mStatus ;
        self.maintainImageView.hidden = NO;
    }
    if (animation) {
         [self rotarionAnimationInView];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopAnimation];
        });
        
    }
}
//刷新和回收哦是同一个按钮
- (IBAction)recoveryAndRefreshBtnClick:(id)sender {
    BOOL IsM = NO;
    if (![self.model.mStatus isEqualToString:@""]) {
        //维护状态
        IsM = YES;
    }
    [self.delegate refreshAndRecouveryByApiId:self.apiId Index:self.indexPath.row IsMaintaining:IsM];
}

-(void)rotarionAnimationInView{
     [self.refreshAndRecoveryBtn setImage:[UIImage imageNamed:@"icon_recycling_orange"] forState:UIControlStateNormal];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = @(M_PI*2);
    animation.repeatCount = MAXFLOAT;
    animation.duration = 1;
    [self.refreshAndRecoveryBtn.imageView.layer addAnimation:animation forKey:@"animation"];
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:246/255.0 blue:230/255.0 alpha:1];
}
-(void)stopAnimation{
    [self.refreshAndRecoveryBtn setImage:[UIImage imageNamed:@"icon_recycling"] forState:UIControlStateNormal];
    [self.refreshAndRecoveryBtn.imageView.layer removeAllAnimations];
    self.backgroundColor = [UIColor whiteColor];
}
@end
