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
}

-(void)awakeFromNib
{
    [super awakeFromNib] ;
    
    self.backgroundColor = colorWithRGB(229, 237, 247) ;
    self.labSummer.font = [UIFont systemFontOfSize:12.0f] ;
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
        titleCell.titleFont = [UIFont systemFontOfSize:11.0f] ;
        titleCell.titleColor = colorWithRGB(85, 85, 85);
    }
    
    NSInteger index = indexPath.section*2 + indexPath.item ;
    switch (index) {
        case 0:
            titleCell.labTitle.text = @"账户余额:0.00";
            break;
        case 1:
            titleCell.labTitle.text = @"中将金额:0.00";
            break;
        case 2:
            titleCell.labTitle.text = @"投注总额:0.00";
            break;
        case 3:
            titleCell.labTitle.text = @"盈  亏:0.00";
            break;
            
        default:
            break;
    }
    
    return titleCell ;
}

@end
