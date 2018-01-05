//
//  RH_CapitalRecordBottomView.m
//  gameBoxEx
//
//  Created by Richard on 04/01/18.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalRecordBottomView.h"
#import "coreLib.h"
#import "CLStaticCollectionViewTitleCell.h"
@interface RH_CapitalRecordBottomView()<CLStaticCollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UILabel *labSummer;
@property (weak, nonatomic) IBOutlet CLStaticCollectionView *summerStaticView;

@end

@implementation RH_CapitalRecordBottomView
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
            titleCell.labTitle.text = @"充值额度:0.00";
            break;
        case 1:
            titleCell.labTitle.text = @"提现总额:0.00";
            break;
        case 2:
            titleCell.labTitle.text = @"优惠总额:0.00";
            break;
        case 3:
            titleCell.labTitle.text = @"反水总额:0.00";
            break;
            
        default:
            break;
    }
    
    return titleCell ;
}
@end
