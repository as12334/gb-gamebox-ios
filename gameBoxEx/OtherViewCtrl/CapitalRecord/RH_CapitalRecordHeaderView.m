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

@interface RH_CapitalRecordHeaderView()<CLStaticCollectionViewDelegate,CLStaticCollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labDateTitle;
/**快选*/
@property (weak, nonatomic) IBOutlet UIButton *btnQuickSelect;
/**搜索*/
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@property (nonatomic,strong,readonly) RH_CapitalStaticDataCell *startCapitalDateCell ;
@property (nonatomic,strong,readonly) RH_CapitalStaticDataCell *endCapitalDateCell ;
@end

@implementation RH_CapitalRecordHeaderView

@synthesize startCapitalDateCell = _startCapitalDateCell    ;
@synthesize endCapitalDateCell = _endCapitalDateCell        ;

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    self.backgroundColor = [UIColor whiteColor] ;
    
    self.btnSearch.backgroundColor = colorWithRGB(44, 103, 182) ;
    [self.btnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    self.btnSearch.layer.cornerRadius = 4.0f ;
    self.btnSearch.layer.masksToBounds = YES ;
    
    WHC_StackView *stackView = [[WHC_StackView alloc] init];
    [self addSubview:stackView];
    stackView.whc_LeftSpaceToView(2, self.labDateTitle).whc_TopSpace(0).whc_BottomSpace(0).whc_RightSpaceToView(0, self.btnQuickSelect);
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
    
    
    self.layer.masksToBounds = YES ;
}

#pragma mark -
-(RH_CapitalStaticDataCell *)startCapitalDateCell
{
    if (!_startCapitalDateCell) {
        _startCapitalDateCell = [RH_CapitalStaticDataCell createInstance];
    }
    return _startCapitalDateCell;
}

-(RH_CapitalStaticDataCell *)endCapitalDateCell
{
    if (!_endCapitalDateCell) {
        _endCapitalDateCell = [RH_CapitalStaticDataCell createInstance];
    }
    return _endCapitalDateCell;
}

@end
