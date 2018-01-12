//
//  RH_MPGameNoticSectionView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/4.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_MPGameNoticHeaderView.h"
#import "RH_MPGameSeletedDateView.h"
#import "coreLib.h"
@interface RH_MPGameNoticHeaderView()
@property (nonatomic,strong,readonly) RH_MPGameSeletedDateView *startSeletedDateView ;
@property (weak, nonatomic) IBOutlet UIView *startDateView;
@property (weak, nonatomic) IBOutlet UIView *ennDateView;
@property (nonatomic,strong,readonly) RH_MPGameSeletedDateView *endSeletedDateView ;
@property (weak, nonatomic) IBOutlet CLSelectionControl *gameTypeControl;
@property (weak, nonatomic) IBOutlet UIButton *kuaixuanBtn;
@end

@implementation RH_MPGameNoticHeaderView
@synthesize startSeletedDateView = _startSeletedDateView;
@synthesize endSeletedDateView = _endSeletedDateView;
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.startDateView addSubview:self.startSeletedDateView];
    [self.ennDateView addSubview:self.endSeletedDateView];
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
        _endSeletedDateView.frame = CGRectMake(0, 0, self.ennDateView.frame.size.width, self.ennDateView.frame.size.height);
        [_endSeletedDateView updateUIWithDate:_endDate];
        [_endSeletedDateView addTarget:self Selector:@selector(endDateHandle)];
    }
    return _endSeletedDateView;
}
-(void)startDateHandle
{
    ifRespondsSelector(self.delegate, @selector(gameNoticHeaderViewStartDateSelected:DefaultDate:)){
        [self.delegate gameNoticHeaderViewStartDateSelected:self DefaultDate:_startDate] ;
    }
}
-(void)endDateHandle
{
    ifRespondsSelector(self.delegate, @selector(gameNoticHeaderViewEndDateSelected:DefaultDate:)){
        [self.delegate gameNoticHeaderViewEndDateSelected:self DefaultDate:_endDate] ;
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
- (IBAction)gameTypeSelected:(id)sender {
    __block RH_MPGameNoticHeaderView *weakSelf = self;
    if (sender==self.kuaixuanBtn) {
        CGRect frame = self.kuaixuanBtn.frame;
        frame.size.width +=100;
        self.block(frame);
    }
    else if (sender==self.gameTypeControl){
        self.block(weakSelf.gameTypeControl.frame);
    }
}

@end
