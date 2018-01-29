//
//  RH_NormalActivithyView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_NormalActivithyView.h"
#import "RH_OpenActivityModel.h"
#import "coreLib.h"
@interface RH_NormalActivithyView()
@property (weak, nonatomic) IBOutlet UIImageView *backDropImageView;
@property (weak, nonatomic) IBOutlet UIView *normalBackDropView;
@property (weak, nonatomic) IBOutlet UIView *activityRuleDropView;
@property (weak, nonatomic) IBOutlet UIView *openActivityView;
@property (nonatomic,strong)RH_OpenActivityModel *openActivityModel;
//normalActivity
@property (weak, nonatomic) IBOutlet UIButton *openActivityFriestBtn;
@property (weak, nonatomic) IBOutlet UILabel *nextOpentimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTimesLabel;

//openActivity
@property (weak, nonatomic) IBOutlet UILabel *gainActivityLabel;
@property (weak, nonatomic) IBOutlet UIButton *openActivityBtn;
@property (weak, nonatomic) IBOutlet UILabel *gainTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gainDrawTimeLabel;

@property(nonatomic,strong)NSNumber *markRuleNumber;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (nonatomic,strong)NSString *getCurrentTime;
@end
@implementation RH_NormalActivithyView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.userInteractionEnabled = YES;
        self.openActivityModel = [[RH_OpenActivityModel alloc]init];
        [self.normalBackDropView setHidden: NO];
        [self.activityRuleDropView setHidden:YES];
        [self.openActivityView setHidden:YES];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.descriptionTextView setEditable:NO];
    
}
-(void)setActivityModel:(RH_ActivityModel *)activityModel
{
    _activityModel = activityModel;
    self.descriptionTextView.text = self.activityModel.mDescription;
}
-(void)setStatusModel:(RH_ActivityStatusModel *)statusModel
{
//    if (![_statusModel isEqual:statusModel]) {
        _statusModel = statusModel;
        [self.nextOpentimeLabel setText:self.statusModel.mNextLotteryTime];
        [self.activityTimesLabel setText:self.statusModel.mDrawTimes];
        if ([self.statusModel.mDrawTimes isEqualToString:@"-1"]) {
            [self.activityTimesLabel setText:@"活动已结束"];
            [self.openActivityFriestBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityFriestBtn.userInteractionEnabled = NO;
        }
        else if ([self.statusModel.mDrawTimes isEqualToString:@"-5"]){
            [self.activityTimesLabel setText:@"红包已抢光"];
            [self.openActivityFriestBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityFriestBtn.userInteractionEnabled = NO;
        }
        else if ([self.statusModel.mDrawTimes isEqualToString:@"0"]){
            [self.activityTimesLabel setText:@"红包已抢光"];
            [self.openActivityFriestBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityFriestBtn.userInteractionEnabled = NO;
        }
        else
        {
            [self.openActivityFriestBtn setBackgroundImage:[UIImage imageNamed:@"button-01"] forState:UIControlStateNormal];
            self.openActivityFriestBtn.userInteractionEnabled = YES;
        }
//    }
}
-(void)setOpenModel:(RH_OpenActivityModel *)openModel
{
        _openModel = openModel;
        [self.gainTimeLabel setText:self.openModel.mNextLotteryTime];
        [self.gainActivityLabel setText:self.openModel.mGameNum];
        if ([self.openModel.mGameNum isEqualToString:@"-1"]) {
            self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
            [self.gainActivityLabel setText:@"已抽完"];
            [self.gainDrawTimeLabel setText:nil];
            [self.gainTimeLabel setText:nil];
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = NO;
        }
        else if ([self.openModel.mGameNum isEqualToString:@"0"]) {
            self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
            [self.gainActivityLabel setText:@"已结束"];
            [self.gainDrawTimeLabel setText:nil];
            [self.gainTimeLabel setText:nil];
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = NO;
        }
        else if ([self.openModel.mGameNum isEqualToString:@"-2"]) {
            self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
            [self.gainActivityLabel setText:@"抽奖异常"];
            [self.gainDrawTimeLabel setText:nil];
            [self.gainTimeLabel setText:nil];
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = NO;
        }
        else if ([self.openModel.mGameNum isEqualToString:@"-3"]) {
            self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
            [self.gainActivityLabel setText:@"红包活动结束"];
            [self.gainDrawTimeLabel setText:nil];
            [self.gainTimeLabel setText:nil];
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = NO;
        }
        else if ([self.openModel.mGameNum isEqualToString:@"-4"]) {
            self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
            [self.gainActivityLabel setText:@"条件不满足"];
            [self.gainDrawTimeLabel setText:nil];
            [self.gainTimeLabel setText:nil];
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = NO;
        }
        else if ([self.openModel.mGameNum isEqualToString:@"-5"]) {
            self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
            [self.gainActivityLabel setText:@"已抢完"];
            [self.gainDrawTimeLabel setText:nil];
            [self.gainTimeLabel setText:nil];
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = NO;
        }
        else
        {
            if ([self.openModel.mAward isEqualToString:@"0"]) {
                 self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
                self.gainActivityLabel.text = @"未中奖";
            }
            else{
                self.backDropImageView.image = [UIImage imageNamed:@"hongbao-02"];
                self.gainActivityLabel.text = [NSString stringWithFormat:@"获得%@圆",self.openModel.mAward] ;
            }
            self.gainDrawTimeLabel.text = self.openModel.mGameNum;
            self.gainTimeLabel.text = self.openModel.mNextLotteryTime;
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-01"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = YES;
        }
}
- (IBAction)gameRuleSeletcd:(id)sender {
    self.backDropImageView.image = [UIImage imageNamed:@"hongbao-03"];
    self.descriptionTextView.text = self.activityModel.mDescription;
    [self.normalBackDropView setHidden: YES];
    [self.activityRuleDropView setHidden:NO];
    [self.openActivityView setHidden:YES];
     self.markRuleNumber = @1;
    
}
- (IBAction)closeClick:(id)sender {
    [self.delegate normalActivityViewCloseActivityClick:self];
    self.backDropImageView.image = [UIImage imageNamed:@"hongbao-04"];
    [self.normalBackDropView setHidden: NO];
    [self.activityRuleDropView setHidden:YES];
    [self.openActivityView setHidden:YES];
    
}
- (IBAction)firstOpenRuleSelected:(id)sender {
    self.backDropImageView.image = [UIImage imageNamed:@"hongbao-03"];
    self.descriptionTextView.text = self.activityModel.mDescription;
    [self.normalBackDropView setHidden: YES];
    [self.activityRuleDropView setHidden:NO];
    [self.openActivityView setHidden:YES];
    self.markRuleNumber = @0;
}
- (IBAction)besureSeleted:(id)sender {
    if ([self.markRuleNumber isEqual:@1]) {
        self.backDropImageView.image = [UIImage imageNamed:@"hongbao-02"];
        [self.normalBackDropView setHidden: YES];
        [self.activityRuleDropView setHidden:YES];
        [self.openActivityView setHidden:NO];
    }
    else if ([self.markRuleNumber isEqual:@0]){
        self.backDropImageView.image = [UIImage imageNamed:@"hongbao-04"];
        [self.normalBackDropView setHidden: NO];
        [self.activityRuleDropView setHidden:YES];
        [self.openActivityView setHidden:YES];
    }
    
}

- (IBAction)firstOpenActivityClick:(id)sender {
    [self.normalBackDropView setHidden: YES];
    [self.activityRuleDropView setHidden:YES];
    [self.openActivityView setHidden:NO];
//     self.backDropImageView.image = [UIImage imageNamed:@"hongbao-02"];
    ifRespondsSelector(self.delegate, @selector(normalActivityViewFirstOpenActivityClick:)){
        [self.delegate normalActivityViewFirstOpenActivityClick:self] ;
    }
}

- (IBAction)openActivityBtnClick:(id)sender {
    ifRespondsSelector(self.delegate, @selector(normalActivithyViewOpenActivityClick:)){
        [self.delegate normalActivithyViewOpenActivityClick:self] ;
    }
//     self.backDropImageView.image = [UIImage imageNamed:@"hongbao-02"];
    [self.normalBackDropView setHidden: YES];
    [self.activityRuleDropView setHidden:YES];
    [self.openActivityView setHidden:NO];
}
@end
