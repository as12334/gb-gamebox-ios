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

/**
 快选
 */
@property (weak, nonatomic) IBOutlet UIButton *btnQuickSelect;

/**
 搜索
 */
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@property (nonatomic,strong,readonly) RH_CapitalStaticDataCell *startCapitalDateCell ;
@property (nonatomic,strong,readonly) RH_CapitalStaticDataCell *endCapitalDateCell ;
//日期展示
@property (nonatomic,strong) IBOutlet CLStaticCollectionView *selectedDateStaticView ;
@end

@implementation RH_CapitalRecordHeaderView
{
    NSArray *_typeHeaderList ;
}

@synthesize startCapitalDateCell = _startCapitalDateCell    ;
@synthesize endCapitalDateCell = _endCapitalDateCell        ;

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    _typeHeaderList = @[@"全 部",@"充 值",@"提 现",@"礼 金",@"投 注"] ;
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
    //    self.selectedDateStaticView.dataSource = self ;
    //    self.selectedDateStaticView.delegate = self ;
    //    self.selectedDateStaticView.allowSelection = YES ;
    //    self.selectedDateStaticView.allowCellSeparationLine = NO ;
    //    self.selectedDateStaticView.allowSectionSeparationLine = NO ;
    //    self.selectedDateStaticView.averageCellWidth = NO ;
    //    self.selectedDateStaticView.separationLineColor = RH_Line_DefaultColor ;
    //    self.selectedDateStaticView.backgroundColor = [UIColor clearColor] ;
    //    [self.selectedDateStaticView reloadData] ;
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

#pragma mark-
- (NSUInteger)staticCollectionView:(CLStaticCollectionView *)collectionView numberOfItemsInSection:(NSUInteger)section
{
    return 3 ;
}

- (CLStaticCollectionViewCell *)staticCollectionView:(CLStaticCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==0){
        RH_CapitalStaticDataCell * cell = [collectionView dequeueReusableCellWithIdentifier:[RH_CapitalStaticDataCell defaultReuseIdentifier]] ;
        if (!cell){
            cell = [RH_CapitalStaticDataCell createInstance]  ;
            [cell setupReuseIdentifier:[RH_CapitalStaticDataCell defaultReuseIdentifier]] ;
        }
        
        return  cell ;
    }else if (indexPath.item==1){
        CLStaticCollectionViewTitleCell * cell = [collectionView dequeueReusableCellWithIdentifier:[CLStaticCollectionViewTitleCell defaultReuseIdentifier]] ;
        if (!cell){
            cell = [CLStaticCollectionViewTitleCell createInstance]  ;
            [cell setupReuseIdentifier:[CLStaticCollectionViewTitleCell defaultReuseIdentifier]] ;
        }
        
        cell.labTitle.text = @"~" ;
        cell.labTitle.textColor = colorWithRGB(51, 51, 51) ;
        
        return  cell ;
    }else if (indexPath.item==2){
        RH_CapitalStaticDataCell * cell = [collectionView dequeueReusableCellWithIdentifier:[RH_CapitalStaticDataCell defaultReuseIdentifier]] ;
        if (!cell){
            cell = [RH_CapitalStaticDataCell createInstance]  ;
            [cell setupReuseIdentifier:[RH_CapitalStaticDataCell defaultReuseIdentifier]] ;
        }
        
        return  cell ;
    }
    
    return nil ;
}

- (NSString*)staticCollectionView:(CLStaticCollectionView *)collectionView cellWidthWeightAtIndexPath:(NSUInteger)section
{
    return @"5:1:5" ;
}

-(void)staticCollectionView:(CLStaticCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO] ;
    if (indexPath.item==0){
        
        [self.selectedDateStaticView reloadData] ;
    }else if (indexPath.item==2){
        
        [self.selectedDateStaticView reloadData] ;
    }
}

@end
