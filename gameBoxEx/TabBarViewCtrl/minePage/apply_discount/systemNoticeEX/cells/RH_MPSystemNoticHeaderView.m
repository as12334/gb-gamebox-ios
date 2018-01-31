//
//  RH_MPGameNoticSectionView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPSystemNoticHeaderView.h"
#import "RH_MPGameSeletedDateView.h"
@interface RH_MPSystemNoticHeaderView()
@property (weak, nonatomic) IBOutlet UIView *startDateView;
@property (weak, nonatomic) IBOutlet UIView *endDateView;
@property (nonatomic,strong,readonly) RH_MPGameSeletedDateView *startSeletedDateView ;
@property (nonatomic,strong,readonly) RH_MPGameSeletedDateView *endSeletedDateView ;
@property (weak, nonatomic) IBOutlet UIButton *kuaixuanBtn;
@end
@implementation RH_MPSystemNoticHeaderView
@synthesize startSeletedDateView = _startSeletedDateView;
@synthesize endSeletedDateView = _endSeletedDateView;
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = colorWithRGB(242, 242, 242);
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.startDateView addSubview:self.startSeletedDateView];
    [self.endDateView addSubview:self.endSeletedDateView];
    self.startDateView.layer.cornerRadius = 3.f;
    self.startDateView.layer.borderWidth = 1.f;
    self.startDateView.layer.borderColor = colorWithRGB(226, 226, 226).CGColor;
    self.startDateView.layer.masksToBounds = YES;
    self.endDateView.layer.cornerRadius = 3.f;
    self.endDateView.layer.borderWidth = 1.f;
    self.endDateView.layer.borderColor = colorWithRGB(226, 226, 226).CGColor;
    self.endDateView.layer.masksToBounds = YES;
    self.kuaixuanBtn.layer.cornerRadius = 3.f;
    self.kuaixuanBtn.backgroundColor = colorWithRGB(27, 117, 217);
    [self.kuaixuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.kuaixuanBtn.layer.masksToBounds = YES;
    self.startSeletedDateView.dateLabel.textColor = colorWithRGB(153, 153, 153);
    self.startSeletedDateView.dateLabel.font = [UIFont systemFontOfSize:12.f];
    self.endSeletedDateView.dateLabel.textColor = colorWithRGB(153, 153, 153);
    self.endSeletedDateView.dateLabel.font = [UIFont systemFontOfSize:12.f];
}
-(RH_MPGameSeletedDateView *)startSeletedDateView
{
    if (!_startSeletedDateView) {
        _startSeletedDateView = [RH_MPGameSeletedDateView createInstance];
        _startSeletedDateView.frame = CGRectMake(0, 0, self.startDateView.frame.size.width, self.startDateView.frame.size.height);
        [_startSeletedDateView updateUIWithDate:_startDate];
        [_startSeletedDateView addTarget:self Selector:@selector(startDateHandle)];
    }
    return _startSeletedDateView;
}
-(RH_MPGameSeletedDateView *)endSeletedDateView
{
    if (!_endSeletedDateView) {
        _endSeletedDateView = [RH_MPGameSeletedDateView createInstance];
        _endSeletedDateView.frame = CGRectMake(0, 0, self.endDateView.frame.size.width, self.endDateView.frame.size.height);
        [_endSeletedDateView updateUIWithDate:_endDate];
        [_endSeletedDateView addTarget:self Selector:@selector(endDateHandle)];
    }
    return _endSeletedDateView;
}
-(void)startDateHandle
{
    ifRespondsSelector(self.delegate, @selector(gameSystemHeaderViewStartDateSelected:DefaultDate:)){
        [self.delegate gameSystemHeaderViewStartDateSelected:self DefaultDate:_startDate] ;
    }
}
-(void)endDateHandle
{
    ifRespondsSelector(self.delegate, @selector(gameSystemHeaderViewEndDateSelected:DefaultDate:)){
        [self.delegate gameSystemHeaderViewEndDateSelected:self DefaultDate:_endDate] ;
    }
}
#pragma mark ---
-(void)setStartDate:(NSDate *)startDate
{
    if (![_startDate isEqualToDate:startDate]){
        _startDate = startDate;
        [self.startSeletedDateView updateUIWithDate:_startDate];
    }
}

-(void)setEndDate:(NSDate *)endDate
{
    if(![_endDate isEqualToDate:endDate]){
        _endDate = endDate;
        [self.endSeletedDateView updateUIWithDate:_endDate];
    }
}
- (IBAction)kuaixuanSelected:(id)sender {
//    __block RH_MPSystemNoticHeaderView *weakSelf = self;
    CGRect frame = self.kuaixuanBtn.frame;
    self.block(frame);
}

@end
