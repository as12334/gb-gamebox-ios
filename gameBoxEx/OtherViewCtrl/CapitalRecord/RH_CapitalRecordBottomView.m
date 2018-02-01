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
    CGFloat _rechargeSummer ;
    CGFloat _withdrawSummer ;
    CGFloat _favorableSummer ;
    CGFloat _rakebackSummer ;
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
-(void)updateUIInfoWithRechargeSum:(CGFloat)rechargeSum
                       WithDrawSum:(CGFloat)withDrawSum
                      FavorableSum:(CGFloat)favorableSum
                          Rakeback:(CGFloat)rakeBackSum
{
    _rechargeSummer = rechargeSum ;
    _withdrawSummer = withDrawSum ;
    _favorableSummer = favorableSum ;
    _rakebackSummer = rakeBackSum ;
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
    }
    
    NSInteger index = indexPath.section*2 + indexPath.item ;
    switch (index) {
        case 0:
            titleCell.labTitle.text = [NSString stringWithFormat:@"充值总额:%.02f",_rechargeSummer] ;
            break;
        case 1:
            titleCell.labTitle.text = [NSString stringWithFormat:@"提现总额:%.02f",_withdrawSummer] ;
            break;
        case 2:
            titleCell.labTitle.text = [NSString stringWithFormat:@"优惠总额:%.02f",_favorableSummer] ;
            break;
        case 3:
            titleCell.labTitle.text = [NSString stringWithFormat:@"返水总额:%.02f",_rakebackSummer] ;
            break;
            
        default:
            break;
    }
    
    return titleCell ;
}
@end
