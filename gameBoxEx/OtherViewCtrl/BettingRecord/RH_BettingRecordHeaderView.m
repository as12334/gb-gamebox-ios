//
//  RH_BettingRecordHeaderView.m
//  lotteryBox
//
//  Created by luis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BettingRecordHeaderView.h"
#import "RH_BettingStaticDateCell.h"
#import "CLStaticCollectionViewTitleCell.h"
#import "coreLib.h"

@interface RH_BettingRecordHeaderView()<CLStaticCollectionViewDelegate,CLStaticCollectionViewDataSource>
@property (nonatomic,strong) UILabel *labTitle      ;
@property (nonatomic,strong) UIButton *btnSearch    ;
//日期展示
@property (nonatomic,strong) IBOutlet CLStaticCollectionView *selectedDateStaticView ;
@end

@implementation RH_BettingRecordHeaderView
{
    NSArray *_typeHeaderList ;
}

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    _typeHeaderList = @[@"全 部",@"充 值",@"提 现",@"礼 金",@"投 注"] ;
    
    self.labTitle.textColor = colorWithRGB(72, 73, 74) ;
    self.labTitle.font = [UIFont systemFontOfSize:14.0f] ;
    self.btnSearch.backgroundColor = colorWithRGB(44, 103, 182) ;
    [self.btnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    self.btnSearch.layer.cornerRadius = 4.0f ;
    self.btnSearch.layer.masksToBounds = YES ;
    
    self.selectedDateStaticView.dataSource = self ;
    self.selectedDateStaticView.delegate = self ;
    self.selectedDateStaticView.allowSelection = YES ;
    self.selectedDateStaticView.allowCellSeparationLine = NO ;
    self.selectedDateStaticView.allowSectionSeparationLine = NO ;
    self.selectedDateStaticView.averageCellWidth = NO ;
    self.selectedDateStaticView.separationLineColor = RH_Line_DefaultColor ;
    [self.selectedDateStaticView reloadData] ;
}

#pragma mark-
- (NSUInteger)staticCollectionView:(CLStaticCollectionView *)collectionView numberOfItemsInSection:(NSUInteger)section
{
    return 3 ;
}

- (CLStaticCollectionViewCell *)staticCollectionView:(CLStaticCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==0){
        RH_BettingStaticDateCell * cell = [collectionView dequeueReusableCellWithIdentifier:[RH_BettingStaticDateCell defaultReuseIdentifier]] ;
        if (!cell){
            cell = [RH_BettingStaticDateCell createInstance]  ;
            [cell setupReuseIdentifier:[RH_BettingStaticDateCell defaultReuseIdentifier]] ;
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
        RH_BettingStaticDateCell * cell = [collectionView dequeueReusableCellWithIdentifier:[RH_BettingStaticDateCell defaultReuseIdentifier]] ;
        if (!cell){
            cell = [RH_BettingStaticDateCell createInstance]  ;
            [cell setupReuseIdentifier:[RH_BettingStaticDateCell defaultReuseIdentifier]] ;
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
