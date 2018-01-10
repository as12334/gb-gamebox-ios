//
//  RH_NormalActivithyView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_NormalActivithyView.h"
#import "RH_OpenActivityModel.h"
@interface RH_NormalActivithyView()
@property (weak, nonatomic) IBOutlet UIImageView *backDropImageView;
@property (weak, nonatomic) IBOutlet UIView *normalBackDropView;
@property (weak, nonatomic) IBOutlet UIView *activityRuleDropView;
@property (weak, nonatomic) IBOutlet UIView *openActivityView;
@property (nonatomic,strong)RH_OpenActivityModel *openActivityModel;
@property (weak, nonatomic) IBOutlet UILabel *gainActivityLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextOpentimeLabel;
@end
@implementation RH_NormalActivithyView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.userInteractionEnabled = YES;
        self.openActivityModel = [[RH_OpenActivityModel alloc]init];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
}
-(void)setActivityModel:(RH_ActivityModel *)activityModel
{
    if (![_activityModel isEqual:activityModel]){
        _activityModel = activityModel ;
       [self.nextOpentimeLabel setText:self.activityModel.mNextLotteryTime];
    }
    
}
-(void)setOpenModel:(RH_OpenActivityModel *)openModel
{
    if (![_openModel isEqual:openModel]){
        _openModel = openModel ;
        [self.gainActivityLabel setText:self.openModel.mAward];
    }
}
- (IBAction)gameRuleSeletcd:(id)sender {
    self.backDropImageView.image = [UIImage imageNamed:@"hongbao-03"];
    [self.normalBackDropView setHidden: YES];
    [self.activityRuleDropView setHidden:NO];
    [self.openActivityView setHidden:YES];
    
}
- (IBAction)closeClick:(id)sender {
    
}
- (IBAction)besureSeleted:(id)sender {
    self.backDropImageView.image = [UIImage imageNamed:@"hongbao-04"];
    [self.normalBackDropView setHidden: NO];
    [self.activityRuleDropView setHidden:YES];
    [self.openActivityView setHidden:YES];
}
- (IBAction)openActivityBtnClick:(id)sender {
    [self.delegate normalActivithyViewOpenActivityClick:self];
     self.backDropImageView.image = [UIImage imageNamed:@"hongbao-02"];
    [self.normalBackDropView setHidden: YES];
    [self.activityRuleDropView setHidden:YES];
    [self.openActivityView setHidden:NO];
}
@end
