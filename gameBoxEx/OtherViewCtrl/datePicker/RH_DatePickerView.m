//
//  RH_DatePickerView.m
//  gameBoxEx
//
//  Created by lewis on 2018/6/1.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DatePickerView.h"
#import "coreLib.h"
#import "RH_API.h"
#import "MacroDef.h"
#define BXScreenH [UIScreen mainScreen].bounds.size.height
#define BXScreenW [UIScreen mainScreen].bounds.size.width
#define BXScreenBounds [UIScreen mainScreen].bounds
@interface RH_DatePickerView()
//时间选择器
@property(nonatomic,strong,readonly)UIDatePicker *datePicker;
//左侧的说明控件
@property(nonatomic,strong,readonly)UILabel *titleLabel;
//右侧的确定按钮
@property(nonatomic,strong,readonly)UIButton *confirmBtn;
//选择的时间
@property(nonatomic,strong)NSDate *date;

@end
@implementation RH_DatePickerView
@synthesize datePicker = _datePicker;
@synthesize titleLabel = _titleLabel;
@synthesize confirmBtn = _confirmBtn;
@synthesize coverView = _coverView;
+(RH_DatePickerView *)shareCalendarView:(NSString *)title defaultDate:(NSDate *)date
{
    static RH_DatePickerView *datePickerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        datePickerView = [[RH_DatePickerView alloc]initWithFrame:CGRectMake(0,BXScreenH-250, BXScreenW, 250)];
        datePickerView.backgroundColor = [UIColor whiteColor];
    });
    datePickerView.titleLabel.text = title;
    return datePickerView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
#pragma mark ==============creatUI================
-(void)creatUI{
    [[UIApplication sharedApplication].keyWindow addSubview:self.coverView];
    [self addSubview:self.datePicker];
    [self addSubview:self.titleLabel];
    [self addSubview:self.confirmBtn];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
/**
 *  datePicker
 */
-(UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, BXScreenW, 210)];
        //时区
        [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        //默认为当天
        [_datePicker setCalendar:[NSCalendar currentCalendar]];
        //设置日期选择的模
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        //监听datePicker值的改变
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}
/**
 *  titleLabel
 */
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,10 , 150, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.text = @"请选择日期";
    }
    return _titleLabel;
}
/**
 *  confirmBtn
 */
-(UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(BXScreenW-60, 10, 50, 30);
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmDatePicker) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
/**
 *  遮罩层
 */
-(UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BXScreenW, BXScreenH)];
        _coverView.backgroundColor = [UIColor lightGrayColor];
        _coverView.alpha = 0.7;
        _coverView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confirmDatePicker)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}
#pragma mark ==============事件处理================
-(void)dateChange:(UIDatePicker *)datePicker
{
    self.date = datePicker.date;
}
/**
 *  点击确定按钮
 */
-(void)confirmDatePicker
{
    if (self.date==nil) {
        self.date = [NSDate date];
    }
    self.chooseDateBlock(self.date);
    [self removeFromSuperview];
    [self.coverView removeFromSuperview];
}
@end
