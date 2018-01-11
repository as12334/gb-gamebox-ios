//
//  RH_CapitalRecordHeaderView.m
//  gameBoxEx
//
//  Created by Richard on 04/01/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalRecordHeaderView.h"
#import "RH_CapitalStaticDataCell.h"
#import "CLStaticCollectionViewTitleCell.h"
#import "coreLib.h"

@interface RH_CapitalRecordHeaderView()<CapitalRecordHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labDateTitle;
/**快选*/
@property (weak, nonatomic) IBOutlet UIButton *btnQuickSelect;
@property (nonatomic,strong,readonly) RH_CapitalStaticDataCell *startCapitalDateCell ;
@property (nonatomic,strong,readonly) RH_CapitalStaticDataCell *endCapitalDateCell ;
@property (weak, nonatomic) IBOutlet UIButton *serachBtn; //搜索
@property (weak, nonatomic) IBOutlet UILabel *withdrawalLab;  //取款处理中的金额
@property (weak, nonatomic) IBOutlet UILabel *transferLab;//转账处理中的金额
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation RH_CapitalRecordHeaderView

@synthesize startCapitalDateCell = _startCapitalDateCell    ;
@synthesize endCapitalDateCell = _endCapitalDateCell        ;

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor whiteColor] ;
    self.userInteractionEnabled = YES;

    
    self.btnQuickSelect.backgroundColor = colorWithRGB(27, 117, 217);
    [self.btnQuickSelect setTitleColor:colorWithRGB(255, 255, 255) forState:UIControlStateNormal];
    self.btnQuickSelect.layer.cornerRadius = 4.0f ;
    self.btnQuickSelect.layer.masksToBounds = YES ;
    [self.btnQuickSelect addTarget:self action:@selector(quickBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    WHC_StackView *stackView = [[WHC_StackView alloc] init];
    [self addSubview:stackView];
    stackView.whc_LeftSpaceToView(0, self.labDateTitle).whc_TopSpace(0).whc_RightSpaceToView(5, self.btnQuickSelect).whc_Height(44);
    stackView.whc_Column = 2;
    stackView.whc_HSpace = 20;
    stackView.whc_VSpace = 0;
    stackView.whc_Orientation = Horizontal;
    [stackView addSubview:self.startCapitalDateCell];
    [stackView addSubview:self.endCapitalDateCell];
    
    [stackView whc_StartLayout];
    
    UILabel *label_ = [[UILabel alloc] init];
    [stackView addSubview:label_];
    label_.whc_Center(0, 0).whc_Width(30);
    label_.text = @"~";
    label_.textAlignment = NSTextAlignmentCenter;
    
    UIView *view_Line = [UIView new];
    [self addSubview:view_Line];
    view_Line.whc_TopSpaceToView(5, stackView).whc_LeftSpace(10).whc_RightSpace(0).whc_Height(1);
    view_Line.backgroundColor = RH_Line_DefaultColor;
    [self addSubview:self.serachBtn];
    self.serachBtn.backgroundColor = colorWithRGB(27, 117, 217);
    self.serachBtn.layer.cornerRadius = 3.0f;
    self.serachBtn.layer.masksToBounds = YES;
    self.serachBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.serachBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.serachBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view_Line2 = [UIView new];
    [self addSubview:view_Line2];
    view_Line2.whc_TopSpaceToView(10, self.typeLabel).whc_LeftSpace(0).whc_RightSpace(0).whc_Height(1);
    view_Line2.backgroundColor = RH_Line_DefaultColor;
    
    self.withdrawalLab.whc_TopSpaceToView(5, view_Line2).whc_LeftSpace(20).whc_Height(30).whc_Width(screenSize().width/2);
   
    self.transferLab.whc_TopSpaceToView(5, view_Line2).whc_RightSpace(10).whc_Height(30).whc_Width(screenSize().width/2);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeLabelPulldownList)];
    self.typeLabel.backgroundColor = colorWithRGB(27, 117, 217);
    self.typeLabel.layer.cornerRadius = 3.0f;
    self.typeLabel.layer.masksToBounds = YES;
    [self.typeLabel addGestureRecognizer:tap];
    
}

#pragma mark --- 搜索按钮
-(void)searchBtnClick{
    ifRespondsSelector(self.delegate, @selector(capitalRecordHeaderViewTouchSearchButton:)){
        [self.delegate capitalRecordHeaderViewTouchSearchButton:self] ;
    }
}

-(void)quickBtnClick{
    NSLog(@"快选");
}


#pragma mark -startCapitalDateCell
-(RH_CapitalStaticDataCell *)startCapitalDateCell
{
    if (!_startCapitalDateCell) {
        _startCapitalDateCell = [RH_CapitalStaticDataCell createInstance];
        [_startCapitalDateCell updateUIWithDate:_startDate] ;
        [_startCapitalDateCell addTarget:self Selector:@selector(startCapatitalDateCellHandle)] ;
    }
    return _startCapitalDateCell;
}

-(void)startCapatitalDateCellHandle
{
    ifRespondsSelector(self.delegate, @selector(capitalRecordHeaderViewWillSelectedStartDate:DefaultDate:)){
        [self.delegate capitalRecordHeaderViewWillSelectedStartDate:self DefaultDate:_startDate] ;
    }
}

-(RH_CapitalStaticDataCell *)endCapitalDateCell
{
    if (!_endCapitalDateCell) {
        _endCapitalDateCell = [RH_CapitalStaticDataCell createInstance];
        [_endCapitalDateCell updateUIWithDate:_endDate] ;
        [_endCapitalDateCell addTarget:self Selector:@selector(endCapitalDateCellHandle)] ;
    }
    return _endCapitalDateCell;
}


-(void)endCapitalDateCellHandle
{
    ifRespondsSelector(self.delegate, @selector(capitalRecordHeaderViewWillSelectedEndDate:DefaultDate:)){
        [self.delegate capitalRecordHeaderViewWillSelectedEndDate:self DefaultDate:_endDate] ;
    }
}

#pragma mark ---
-(void)setStartDate:(NSDate *)startDate
{
    if (![_startDate isEqualToDate:startDate]){
        _startDate = startDate;
        [self.startCapitalDateCell updateUIWithDate:_startDate];
    }
}

-(void)setEndDate:(NSDate *)endDate
{
    if(![_endDate isEqualToDate:endDate]){
        _endDate = endDate;
        [self.endCapitalDateCell updateUIWithDate:_endDate];
    }
}
#pragma mark 类型下拉列表
-(void)typeLabelPulldownList
{
    self.block(self.typeLabel.frame);
}



@end
