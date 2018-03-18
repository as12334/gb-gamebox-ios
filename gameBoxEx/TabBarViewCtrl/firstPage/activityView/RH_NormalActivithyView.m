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
//comfigActivity
@property (nonatomic,strong)UIButton *configBtn;
@property (nonatomic,strong)UILabel *confirmLabel;
//openActivity
@property (weak, nonatomic) IBOutlet UILabel *gainActivityLabel;
@property (weak, nonatomic) IBOutlet UIButton *openActivityBtn;
@property (weak, nonatomic) IBOutlet UILabel *gainTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gainDrawTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *gameRuleBtn;
@property (weak, nonatomic) IBOutlet UIButton *game1RuleBtn;

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
    //移除游戏规则按钮
//    [self.gameRuleBtn removeFromSuperview];
//    [self.game1RuleBtn removeFromSuperview];  
}
#pragma mark -确定按钮点击
-(void)setActivityModel:(RH_ActivityModel *)activityModel
{
    _activityModel = activityModel;
    self.descriptionTextView.text = [NSString stringWithFormat:@"%@",[self filterHTML:self.activityModel.mDescription]] ;
}

-(NSString *)filterHTML:(NSString *)html{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

-(void)setStatusModel:(RH_ActivityStatusModel *)statusModel
{
//    if (![_statusModel isEqual:statusModel]) {
        _statusModel = statusModel;
    
        [self.activityTimesLabel setText:[NSString stringWithFormat:@"你还有%@次抽奖机会",self.statusModel.mDrawTimes]];
        self.activityTimesLabel.textColor = [UIColor whiteColor] ;
        if ([self.statusModel.mDrawTimes isEqualToString:@"-1"]) {
            [self.activityTimesLabel setText:@"活动已结束"];
            [self.openActivityFriestBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityFriestBtn.userInteractionEnabled = NO;
             [self.nextOpentimeLabel setText:self.statusModel.mNextLotteryTime];
        }
        else if ([self.statusModel.mDrawTimes isEqualToString:@"-5"]){
            [self.activityTimesLabel setText:@"红包已抢光"];
            [self.openActivityFriestBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityFriestBtn.userInteractionEnabled = NO;
             [self.nextOpentimeLabel setText:self.statusModel.mNextLotteryTime];
        }
        else if ([self.statusModel.mDrawTimes isEqualToString:@"0"]){
            [self.activityTimesLabel setText:@"红包已抢光"];
            [self.openActivityFriestBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityFriestBtn.userInteractionEnabled = NO;
             [self.nextOpentimeLabel setText:self.statusModel.mNextLotteryTime];
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
    
        [self.gainActivityLabel setText:@" "];
        if ([self.openModel.mGameNum isEqualToString:@"-1"]) {
            self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // do something
                [self.gainActivityLabel setText:@"已抽完"];
                [self.gainTimeLabel setText:self.openModel.mNextLotteryTime];
            });
            [self.gainDrawTimeLabel setText:nil];
            [self.gainTimeLabel setText:nil];
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = NO;
        }
        else if ([self.openModel.mGameNum isEqualToString:@"0"]) {
            self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // do something
                [self.gainActivityLabel setText:@"已结束"];
                 [self.gainTimeLabel setText:self.openModel.mNextLotteryTime];
            });
            [self.gainDrawTimeLabel setText:nil];
            [self.gainTimeLabel setText:nil];
//            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            [self.openActivityBtn setHidden:YES];
            [self.gameRuleBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = NO;
        }
        else if ([self.openModel.mGameNum isEqualToString:@"-2"]) {
            self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // do something
                [self.gainActivityLabel setText:@"抽奖异常"];
            });
            [self.gainDrawTimeLabel setText:nil];
            [self.gainTimeLabel setText:nil];
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = NO;
        }
        else if ([self.openModel.mGameNum isEqualToString:@"-3"]) {
            self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // do something
                [self.gainActivityLabel setText:@"红包活动结束"];
                 [self.gainTimeLabel setText:self.openModel.mNextLotteryTime];
            });
            [self.gainDrawTimeLabel setText:nil];
            [self.gainTimeLabel setText:nil];
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = NO;
        }
        else if ([self.openModel.mGameNum isEqualToString:@"-4"]) {
            self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // do something
                [self.gainActivityLabel setText:@"条件不满足"];
            });
            
            [self.gainDrawTimeLabel setText:nil];
            [self.gainTimeLabel setText:nil];
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = NO;
        }
        else if ([self.openModel.mGameNum isEqualToString:@"-5"]) {
            self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // do something
                [self.gainActivityLabel setText:@"已抢完"];
                 [self.gainTimeLabel setText:self.openModel.mNextLotteryTime];
            });
            [self.gainDrawTimeLabel setText:nil];
            [self.gainTimeLabel setText:nil];
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-can'topen"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = NO;
        }
        else
        {
            if ([self.openModel.mAward isEqualToString:@"0"]) {
                 self.backDropImageView.image = [UIImage imageNamed:@"hongbao-01"];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    // do something
                    self.gainActivityLabel.text = @"未中奖";
                });
            }
            else{
                self.backDropImageView.image = [UIImage imageNamed:@"hongbao-02"];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    // do something
                    self.gainActivityLabel.text = [NSString stringWithFormat:@"获得%@元",self.openModel.mAward] ;
                });
                
            }
            self.gainDrawTimeLabel.text =[NSString stringWithFormat:@"你还有%@次抽奖机会",self.openModel.mGameNum];
             self.gainDrawTimeLabel.textColor = [UIColor whiteColor] ;
//            self.gainTimeLabel.text = self.openModel.mNextLotteryTime;
            [self.openActivityBtn setBackgroundImage:[UIImage imageNamed:@"button-03"] forState:UIControlStateNormal];
            self.openActivityBtn.userInteractionEnabled = YES;
        }
    [self.normalBackDropView setHidden: YES];
    [self.activityRuleDropView setHidden:YES];
    [self.openActivityView setHidden:NO];
}
- (IBAction)gameRuleSeletcd:(id)sender {
    self.backDropImageView.image = [UIImage imageNamed:@"hongbao-03"];
    self.descriptionTextView.text = [NSString stringWithFormat:@"%@",[self filterHTML:self.activityModel.mDescription]] ;
    [self.normalBackDropView setHidden: YES];
    [self.activityRuleDropView setHidden:NO];
    [self.openActivityView setHidden:YES];
     self.markRuleNumber = @1;

}
- (IBAction)closeClick:(id)sender {
    [self.delegate normalActivityViewCloseActivityClick:self];
    //防止再次点开红包后label会预留上次的数据
    self.gainActivityLabel.text = @" ";
    [_confirmLabel removeFromSuperview];
    [_configBtn removeFromSuperview];
    self.backDropImageView.image = [UIImage imageNamed:@"hongbao-04"];
    [self.normalBackDropView setHidden: NO];
    [self.activityRuleDropView setHidden:YES];
    [self.openActivityView setHidden:YES];
    
}
- (IBAction)firstOpenRuleSelected:(id)sender {
    self.backDropImageView.image = [UIImage imageNamed:@"hongbao-03"];
    self.descriptionTextView.text = [NSString stringWithFormat:@"%@",[self filterHTML:self.activityModel.mDescription]] ;
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

     self.backDropImageView.image = [UIImage imageNamed:@"hongbao-04"];
    _configBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_configBtn setBackgroundImage:[UIImage imageNamed:@"button-01"] forState:UIControlStateNormal];
    _configBtn.frame = CGRectMake(0, 0, 50, 50);
    _configBtn.center = CGPointMake(self.normalBackDropView.center.x, self.normalBackDropView.center.y-30);
    _confirmLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    _confirmLabel.center = CGPointMake(self.normalBackDropView.center.x, self.normalBackDropView.center.y+60);
    _confirmLabel.text = self.gainDrawTimeLabel.text;
    _confirmLabel.font = [UIFont systemFontOfSize:12.f];
    _confirmLabel.textAlignment = NSTextAlignmentCenter;
    _confirmLabel.textColor = [UIColor whiteColor];
    [self addSubview:_confirmLabel];
    
    [_configBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_configBtn];
    [self.normalBackDropView setHidden: YES];
    [self.activityRuleDropView setHidden:YES];
    [self.openActivityView setHidden:YES];
}
-(void)click
{
    ifRespondsSelector(self.delegate, @selector(normalActivithyViewOpenActivityClick:)){
                [self.delegate normalActivithyViewOpenActivityClick:self] ;
            }
//        self.backDropImageView.image = [UIImage imageNamed:@"hongbao-04"];
    [self.configBtn removeFromSuperview];
    [self.confirmLabel removeFromSuperview];
}
@end
