//
//  CLCalendarView.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLCalendarView.h"
#import "MacroDef.h"
#import "CLLineLayer.h"
#import "UIView+FrameSize.h"

#define BXScreenH [UIScreen mainScreen].bounds.size.height
#define BXScreenW [UIScreen mainScreen].bounds.size.width
#define BXScreenBounds [UIScreen mainScreen].bounds


@interface CLCalendarView()
@property(nonatomic,readonly,strong) UILabel *labTitle ;
@property(nonatomic,readonly,strong) CLLineLayer *titleSeprationLine ;
@property(nonatomic,readonly,strong) UIDatePicker *datePicker  ;
@property(nonatomic,readonly,strong) UIButton *confirmButton ;
@property(nonatomic,readonly,strong) UIButton *cancelButton ;

@property(nonatomic,strong) NSString *defaultDate       ;

@end

@implementation CLCalendarView

@synthesize labTitle = _labTitle                        ;
@synthesize titleSeprationLine = _titleSeprationLine    ;
@synthesize datePicker = _datePicker                    ;
@synthesize confirmButton = _confirmButton              ;
@synthesize cancelButton = _cancelButton                ;

+(CLCalendarView*)shareCalendarView:(NSString*)title defaultDate:(NSString*)defaultDate
{
    static CLCalendarView* _shareCalendarView = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        _shareCalendarView = [[CLCalendarView alloc] initWithFrame:CGRectMake(114*BXScreenW/414/2,
//                                                                              100*BXScreenW/414,
//                                                                              340*BXScreenW/414,
//                                                                              350*BXScreenH/736)] ;
        _shareCalendarView = [[CLCalendarView alloc] initWithFrame:CGRectMake(0,
                                                                              BXScreenH - (350*BXScreenH/736),
                                                                              BXScreenW,
                                                                              350*BXScreenH/736)] ;

        _shareCalendarView.backgroundColor = colorWithRGB(245, 245, 245);
    });

    _shareCalendarView.labTitle.text = title?:@"日期设置" ;
    _shareCalendarView.defaultDate = defaultDate ;
    return _shareCalendarView;
}

-(instancetype)init
{
    self = [super init] ;
    if (self){
        [self setupInfo] ;
    }

    return self ;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame] ;
    if (self){
        [self setupInfo] ;
    }

    return self ;
}

-(void)setupInfo
{
    [self addSubview:self.labTitle] ;
    //constraint
    setEdgeConstraint(self.labTitle, NSLayoutAttributeTop, self, 15.0f) ;
    setEdgeConstraint(self.labTitle, NSLayoutAttributeLeft, self, 15.0f) ;

    [self addSubview:self.datePicker];

    
    
   
    
    setRelatedCommonAttrConstraint(self.datePicker, NSLayoutAttributeCenterX, self,1.f,0.f);

    [self addSubview:self.confirmButton];
    setEdgeConstraint(self.confirmButton, NSLayoutAttributeTop, self, 15.0f) ;
    setEdgeConstraint(self.confirmButton, NSLayoutAttributeRight, self, 15.0f) ;
    setSizeConstraint(self.confirmButton, NSLayoutAttributeWidth, 80.0f );
    setSizeConstraint(self.confirmButton, NSLayoutAttributeHeight, 30.0f );

//    [self addSubview:self.cancelButton];
//    setRelatedCommonAttrConstraint(self.cancelButton, NSLayoutAttributeCenterX, self,1.f,-60.f);
//    setEdgeConstraint(self.cancelButton, NSLayoutAttributeBottom, self, -15.0f) ;
//    setSizeConstraint(self.cancelButton, NSLayoutAttributeWidth, 80.0f );
//    setSizeConstraint(self.cancelButton, NSLayoutAttributeHeight, 30.0f );
}

#pragma mark-
-(void)setDefaultDate:(NSString *)defaultDate
{
    if (_defaultDate!=defaultDate){
        _defaultDate = defaultDate ;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"] ;
        NSDate *date = [dateFormatter dateFromString:defaultDate] ;
        if (date){
            [self.datePicker setDate:date animated:NO] ;
        }
    }
}

-(UILabel*)labTitle
{
    if (!_labTitle){
        _labTitle = [[UILabel alloc] init];
        _labTitle.translatesAutoresizingMaskIntoConstraints = NO ;
        _labTitle.font = [UIFont systemFontOfSize:20];
        _labTitle.text = @"日期设置" ;
        _labTitle.layer.cornerRadius = 1.0;
        _labTitle.layer.masksToBounds = YES;
    }

    return _labTitle ;
}

-(CLLineLayer*)titleSeprationLine
{
    if (!_titleSeprationLine){
        _titleSeprationLine = [CLLineLayer layer] ;
        _titleSeprationLine.lineWidth = PixelToPoint(2.0f) ;
        _titleSeprationLine.lineColor = [UIColor grayColor] ;

    }

    return _titleSeprationLine ;
}

-(UIButton*)confirmButton
{
    if (!_confirmButton){
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.translatesAutoresizingMaskIntoConstraints = NO ;
        [_confirmButton addTarget:self action:@selector(confirmButtonHandle:) forControlEvents:UIControlEventTouchUpInside];

        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal] ;

        _confirmButton.backgroundColor = [UIColor clearColor];
        _confirmButton.layer.cornerRadius = 5.0;
    }

    return _confirmButton ;
}

-(UIButton*)cancelButton
{
    if (!_cancelButton){
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO ;
        [_cancelButton addTarget:self action:@selector(cancelButtonHandle:) forControlEvents:UIControlEventTouchUpInside];

        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted] ;

        _cancelButton.backgroundColor = [UIColor redColor];
        _cancelButton.layer.cornerRadius = 5.0;
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }

    return _cancelButton ;
}

-(UIDatePicker*)datePicker
{
    if (!_datePicker){
//        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,
//                                                                       80*BXScreenH/736,
//                                                                       330*BXScreenW/414,
//                                                                       200*BXScreenH/736)];
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,40,BXScreenW,
                                                                    self.boundHeigh - 40.0f)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
//        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//        fmt.dateFormat = @"yyyy-MM-dd";
//        NSDate *minDate = [fmt dateFromString:@"2018-1-20"];
//        //设置日期最小值
//        _datePicker.minimumDate = minDate;
        
//        [_datePicker addTarget:self action:@selector(datePickerChangedHandle:) forControlEvents: UIControlEventValueChanged];
    }
    return _datePicker ;
}



- (void)datePickerChangedHandle:(UIDatePicker *)senser{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//
//    pinStr = [formatter stringFromDate:senser.date];
//
}

-(void)confirmButtonHandle:(id)sender
{
    ifRespondsSelector(self.delegate, @selector(calendarViewTouchConfirmButton:SelectDate:)){
        [self.delegate calendarViewTouchConfirmButton:self SelectDate:_datePicker.date] ;
    }
}

-(void)cancelButtonHandle:(id)sender
{
    ifRespondsSelector(self.delegate, @selector(calendarViewTouchCancelButton:)){
        [self.delegate calendarViewTouchCancelButton:self] ;
    }
}

#pragma mark-

-(void)layoutSubviews
{
    [super layoutSubviews] ;

    if (_titleSeprationLine.superlayer){
        [_titleSeprationLine removeFromSuperlayer] ;
        _titleSeprationLine = nil ;
    }

    //蓝色分界线
    self.titleSeprationLine.startPoint = CGPointMake(10, CGRectGetMaxY(self.labTitle.frame)+10.0f) ;
    self.titleSeprationLine.endPoint = CGPointMake(self.boundWidth, CGRectGetMaxY(self.labTitle.frame)+10.0f) ;
    [self.layer addSublayer:self.titleSeprationLine] ;
}

@end
