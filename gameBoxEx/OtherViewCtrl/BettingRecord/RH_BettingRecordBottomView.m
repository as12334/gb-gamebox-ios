//
//  RH_BettingRecordBottomView.m
//  lotteryBox
//
//  Created by luis on 2017/12/12.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BettingRecordBottomView.h"
#import "coreLib.h"
#import "CLStaticCollectionViewTitleCell.h"


/**************************************************************************************************/
/**************************************************************************************************/


@interface RH_BettingRecordBottomView()<CLStaticCollectionViewDataSource>
@property (nonatomic,strong) IBOutlet UILabel *labSummer ;
@property (nonatomic,strong) IBOutlet CLStaticCollectionView *summerStaticView ;
@end

@implementation RH_BettingRecordBottomView
{
    NSArray *_statusFooterList ;
    NSInteger _totalNumber;
    CGFloat _single;
    CGFloat _profitAmount;
    CGFloat _effective;
    
}

/**
 @param totalNumber 笔数
 @param single 投注总额
 @param profitAmount 派彩奖金
 @param effective 有效投注
 */
-(void)updateUIInfoWithTotalNumber:(NSInteger)totalNumber SigleAmount:(CGFloat)single ProfitAmount:(CGFloat)profitAmount effective:(CGFloat)effective
{
    _totalNumber = totalNumber ;
    _single = single ;
    _profitAmount = profitAmount ;
    _effective = effective ;
    [self.summerStaticView reloadData];
}

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    
    self.backgroundColor = colorWithRGB(229, 237, 247) ;
    self.labSummer.font = [UIFont systemFontOfSize:14.0f] ;
    self.labSummer.textColor = colorWithRGB(99, 99, 99);
    self.labSummer.text = @"合计:" ;
    
    self.summerStaticView.backgroundColor = [UIColor clearColor] ;
    self.summerStaticView.dataSource = self ;
    self.summerStaticView.allowSelection = NO ;
    self.summerStaticView.allowCellSeparationLine = NO ;
    self.summerStaticView.allowSectionSeparationLine = NO ;
    [self.summerStaticView reloadData] ;
}

#pragma mark-
- (NSUInteger)numberOfSectionInStaticCollectionView:(CLStaticCollectionView *)collectionView
{
    return 2 ;
}

- (NSUInteger)staticCollectionView:(CLStaticCollectionView *)collectionView numberOfItemsInSection:(NSUInteger)section
{
    return 2 ;
}

- (CLStaticCollectionViewCell *)staticCollectionView:(CLStaticCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CLStaticCollectionViewTitleCell *titleCell = [collectionView dequeueReusableCellWithIdentifier:[CLStaticCollectionViewTitleCell defaultReuseIdentifier]] ;
    if (!titleCell){
        titleCell = [CLStaticCollectionViewTitleCell createInstance]  ;
        [titleCell setupReuseIdentifier:[CLStaticCollectionViewTitleCell defaultReuseIdentifier]] ;
        titleCell.backgroundColor = [UIColor clearColor];
        titleCell.titleFont = [UIFont systemFontOfSize:14.0f] ;
        titleCell.titleColor = colorWithRGB(85, 85, 85);
        titleCell.labTitle.textAlignment = NSTextAlignmentLeft ;
        
        //配制 layout
        titleCell.labTitle.whc_LeftSpace(10).whc_CenterY(0).whc_WidthAuto() ;
    }
    
    NSInteger index = indexPath.section*2 + indexPath.item ;
    switch (index) {
        case 0:
            titleCell.labTitle.text = [NSString stringWithFormat: @"投注总额:%.2f", _single];
            break;
        case 1:
            titleCell.labTitle.text = [NSString stringWithFormat: @"派彩奖金:%.2f", _profitAmount];
            break;
        case 2:
            titleCell.labTitle.text = [NSString stringWithFormat: @"有效投注:%.2f", _effective];
            break;
        case 3:
            titleCell.labTitle.text = [NSString stringWithFormat: @"投注注数:%ld笔", _totalNumber];
            break;
            
        default:
            break;
    }
    
    return titleCell ;
}



@end
