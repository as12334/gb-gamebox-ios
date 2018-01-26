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
//normalActivity
@property (weak, nonatomic) IBOutlet UIButton *openActivityFriestBtn;
@property (weak, nonatomic) IBOutlet UILabel *nextOpentimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTimesLabel;

//openActivity
@property (weak, nonatomic) IBOutlet UILabel *gainActivityLabel;
@property (weak, nonatomic) IBOutlet UIButton *openActivityBtn;
@property (weak, nonatomic) IBOutlet UILabel *gainTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gainDrawTimeLabel;


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
-(void)setStatusModel:(RH_ActivityStatusModel *)statusModel
{
    if (![_statusModel isEqual:statusModel]) {
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
    }
}

-(void)setActivityModel:(RH_ActivityModel *)activityModel
{
    if (![_activityModel isEqual:activityModel]){
        _activityModel = activityModel ;
       [self.nextOpentimeLabel setText:self.activityModel.mNextLotteryTime];
        [self.activityTimesLabel setText:self.activityModel.mDrawTimes];
        if ([self.activityModel.mDrawTimes isEqualToString:@"-1"]) {
            [self.activityTimesLabel setText:@"活动已结束"];
            [self.openActivityFriestBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityFriestBtn.userInteractionEnabled = NO;
        }
        else if ([self.activityModel.mDrawTimes isEqualToString:@"-5"]){
             [self.activityTimesLabel setText:@"红包已抢光"];
            [self.openActivityFriestBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityFriestBtn.userInteractionEnabled = NO;
        }
        else if ([self.activityModel.mDrawTimes isEqualToString:@"0"]){
            [self.activityTimesLabel setText:@"红包已抢光"];
            [self.openActivityFriestBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityFriestBtn.userInteractionEnabled = NO;
        }
        else
        {
            [self.openActivityFriestBtn setBackgroundImage:[UIImage imageNamed:@"button-01"] forState:UIControlStateNormal];
            self.openActivityFriestBtn.userInteractionEnabled = YES;
        }
            
        [self.gainTimeLabel setText:self.activityModel.mNextLotteryTime];
        [self.gainDrawTimeLabel setText:self.activityModel.mDrawTimes];
        if ([self.activityModel.mDrawTimes isEqualToString:@"-1"]) {
            [self.gainDrawTimeLabel setText:@"活动已结束"];
        }
        else if ([self.activityModel.mDrawTimes isEqualToString:@"-5"]){
            [self.gainDrawTimeLabel setText:@"红包已抢光"];
        }
    }
}
//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
-(void)setOpenModel:(RH_OpenActivityModel *)openModel
{
    
    if (![_openModel.mGameNum isEqual:openModel.mGameNum]){
        _openModel = openModel ;
        [self.gainActivityLabel setText:self.openModel.mAward];
        if ([self.openModel.mGameNum isEqualToString:@"0"]) {
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            [self.openActivityFriestBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled=NO;
            self.openActivityFriestBtn.userInteractionEnabled = NO;
        }
        else
        {
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-01"] forState:UIControlStateNormal];
            [self.openActivityFriestBtn setBackgroundImage:[UIImage imageNamed:@"button-01"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled=YES;
            self.openActivityFriestBtn.userInteractionEnabled = YES;
        }
        [self.nextOpentimeLabel setText:self.openModel.mNextLotteryTime];
        [self.activityTimesLabel setText:self.openModel.mGameNum];
        if ([self.openModel.mGameNum isEqualToString:@"-1"]) {
            [self.activityTimesLabel setText:@"活动已结束"];
        }
        else if ([self.openModel.mGameNum isEqualToString:@"-5"]){
            [self.activityTimesLabel setText:@"红包已抢光"];
        }
        [self.gainTimeLabel setText:self.openModel.mNextLotteryTime];
        [self.gainDrawTimeLabel setText:self.openModel.mGameNum];
        if ([self.openModel.mGameNum isEqualToString:@"-1"]) {
            [self.gainDrawTimeLabel setText:@"活动已结束"];
        }
        else if ([self.openModel.mGameNum isEqualToString:@"-5"]){
            [self.gainDrawTimeLabel setText:@"红包已抢光"];
        }
    }
}
- (IBAction)gameRuleSeletcd:(id)sender {
    self.backDropImageView.image = [UIImage imageNamed:@"hongbao-03"];
    self.descriptionTextView.text = self.activityModel.mDescription;
    [self.normalBackDropView setHidden: YES];
    [self.activityRuleDropView setHidden:NO];
    [self.openActivityView setHidden:YES];
    
}
- (IBAction)closeClick:(id)sender {
    [self.delegate normalActivityViewCloseActivityClick:self];
    self.backDropImageView.image = [UIImage imageNamed:@"hongbao-04"];
    [self.normalBackDropView setHidden: NO];
    [self.activityRuleDropView setHidden:YES];
    [self.openActivityView setHidden:YES];
    
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
