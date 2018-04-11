//
//  RH_BettingRecordHeaderView.m
//  lotteryBox
//
//  Created by luis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BettingRecordHeaderView.h"
#import "RH_BettingSelectedDateView.h"
#import "CLStaticCollectionViewTitleCell.h"
#import "coreLib.h"

@interface RH_BettingRecordHeaderView()
@property (nonatomic,strong) IBOutlet UILabel *labTitle      ;
@property (nonatomic,strong) IBOutlet UIButton *btnSearch    ;
@property (nonatomic,strong,readonly) RH_BettingSelectedDateView *startBettingDateCell ;
@property (nonatomic,strong,readonly) RH_BettingSelectedDateView *endBettingDateCell ;

@end

@implementation RH_BettingRecordHeaderView
@synthesize startBettingDateCell = _startBettingDateCell    ;
@synthesize endBettingDateCell = _endBettingDateCell        ;

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor whiteColor] ;
    
    
    self.labTitle.textColor = colorWithRGB(51, 51, 51) ;
    self.labTitle.font = [UIFont systemFontOfSize:14.0f] ;
    self.labTitle.adjustsFontSizeToFitWidth = YES;
    if ([THEMEV3 isEqualToString:@"green"]){
        self.btnSearch.backgroundColor =  RH_NavigationBar_BackgroundColor_Green;
    }else if ([THEMEV3 isEqualToString:@"red"]){
        self.btnSearch.backgroundColor =  RH_NavigationBar_BackgroundColor_Red;
    }else if ([THEMEV3 isEqualToString:@"black"]){
        self.btnSearch.backgroundColor =  ColorWithNumberRGB(0x1766bb);
    }else if ([THEMEV3 isEqualToString:@"blue"]){
        self.btnSearch.backgroundColor =  RH_NavigationBar_BackgroundColor_Blue;
    }else if ([THEMEV3 isEqualToString:@"orange"]){
        self.btnSearch.backgroundColor =  RH_NavigationBar_BackgroundColor_Orange;
    }else{
        self.btnSearch.backgroundColor =  RH_NavigationBar_BackgroundColor;
    }
    
    [self.btnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    self.btnSearch.layer.cornerRadius = 4.0f ;
    self.btnSearch.layer.masksToBounds = YES ;
    
    _startDate = [NSDate date] ;
    _endDate = [NSDate date]  ;
    
    WHC_StackView *stackView = [[WHC_StackView alloc] init];
    
    [self addSubview:stackView];
    stackView.whc_LeftSpaceToView(2, self.labTitle).whc_TopSpace(0).whc_BottomSpace(0).whc_RightSpaceToView(2, self.btnSearch);
    stackView.whc_Column = 2;
    stackView.whc_HSpace = 20;
    stackView.whc_VSpace = 0;
    stackView.whc_Orientation = Horizontal;
    stackView.whc_Edge = UIEdgeInsetsMake(0, 10, 0, 10);
    [stackView addSubview:self.startBettingDateCell];
    [stackView addSubview:self.endBettingDateCell];
    
    [stackView whc_StartLayout];
    
    UILabel *label_ = [[UILabel alloc] init];
    [stackView addSubview:label_];
    label_.whc_Center(0, 0).whc_Width(30);
    label_.text = @"~";
    label_.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - startBettingDateCell
-(RH_BettingSelectedDateView *)startBettingDateCell
{
    if (!_startBettingDateCell){
        _startBettingDateCell =  [RH_BettingSelectedDateView createInstance] ;
        [_startBettingDateCell updateUIWithDate:_startDate] ;
        [_startBettingDateCell addTarget:self Selector:@selector(startBettingDateCellHandle)] ;
    }
    
    return _startBettingDateCell ;
}

-(void)startBettingDateCellHandle
{
    ifRespondsSelector(self.delegate, @selector(bettingRecordHeaderViewWillSelectedStartDate:DefaultDate:)){
        [self.delegate bettingRecordHeaderViewWillSelectedStartDate:self DefaultDate:_startDate] ;
    }
}

#pragma mark -endBettingDateCell
-(RH_BettingSelectedDateView*)endBettingDateCell
{
    if (!_endBettingDateCell){
        _endBettingDateCell =  [RH_BettingSelectedDateView createInstance] ;
        [_endBettingDateCell updateUIWithDate:_endDate] ;
        [_endBettingDateCell addTarget:self Selector:@selector(endBettingDateCellHandle)] ;
    }
    
    return _endBettingDateCell ;
}

-(void)endBettingDateCellHandle
{
    ifRespondsSelector(self.delegate, @selector(bettingRecordHeaderViewWillSelectedEndDate:DefaultDate:)){
        [self.delegate bettingRecordHeaderViewWillSelectedEndDate:self DefaultDate:_endDate] ;
    }
}

#pragma mark -
-(IBAction)btn_touch:(id)sender
{
    ifRespondsSelector(self.delegate, @selector(bettingRecordHeaderViewTouchSearchButton:)){
        [self.delegate bettingRecordHeaderViewTouchSearchButton:self] ;
    }
}

#pragma mark-
-(void)setStartDate:(NSDate *)startDate
{
    if (![_startDate isEqualToDate:startDate]){
        _startDate = startDate ;
        [self.startBettingDateCell updateUIWithDate:_startDate] ;
    }
}

-(void)setEndDate:(NSDate *)endDate
{
    if (![_endDate isEqualToDate:endDate]){
        _endDate = endDate ;
        [self.endBettingDateCell updateUIWithDate:_endDate] ;
    }
}



@end
