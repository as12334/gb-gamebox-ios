//
//  RH_BettingRecordCell.m
//  lotteryBox
//
//  Created by luis on 2017/12/11.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BettingRecordCell.h"
#import "coreLib.h"
#import "RH_BettingInfoModel.h"
#import "CLStaticCollectionViewTitleCell.h"

@interface RH_BettingRecordCell () <CLStaticCollectionViewDataSource>
@property (nonatomic,strong) IBOutlet  CLStaticCollectionView *staticCollectView ;
@property (nonatomic,strong) RH_BettingInfoModel *bettingInfoModel ;
@end

@implementation RH_BettingRecordCell

+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return 40.0f  ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor] ;
    self.separatorLineStyle = CLTableViewCellSeparatorLineStyleLine ;
    self.separatorLineColor = RH_Line_DefaultColor ;
    self.separatorLineWidth = PixelToPoint(1.0F) ;
    
    self.staticCollectView.allowSelection = NO ;
    self.staticCollectView.allowCellSeparationLine = NO ;
    self.staticCollectView.allowSectionSeparationLine = NO ;
    self.staticCollectView.averageCellWidth = NO ;
    self.staticCollectView.userInteractionEnabled = NO ;
    self.staticCollectView.backgroundColor = [UIColor clearColor] ;
    
    self.staticCollectView.dataSource = self ;
    self.selectionOption = CLSelectionOptionHighlighted|CLSelectionOptionSelected ;
    self.selectionColor = RH_Cell_DefaultHolderColor ;
}

-(UIView *)showSelectionView
{
    return self.staticCollectView ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.bettingInfoModel = ConvertToClassPointer(RH_BettingInfoModel, context) ;
    [self.staticCollectView reloadData] ;
}

#pragma mark-
- (NSUInteger)numberOfSectionInStaticCollectionView:(CLStaticCollectionView *)collectionView
{
    return 1 ;
}

- (NSUInteger)staticCollectionView:(CLStaticCollectionView *)collectionView numberOfItemsInSection:(NSUInteger)section
{
    return 5 ;
}

- (CLStaticCollectionViewCell *)staticCollectionView:(CLStaticCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    CLStaticCollectionViewTitleCell *titleCell = [collectionView dequeueReusableCellWithIdentifier:[CLStaticCollectionViewTitleCell defaultReuseIdentifier]] ;
    if (!titleCell){
        titleCell = [CLStaticCollectionViewTitleCell createInstance]  ;
        [titleCell setupReuseIdentifier:[CLStaticCollectionViewTitleCell defaultReuseIdentifier]] ;
        titleCell.backgroundColor = [UIColor clearColor];
        titleCell.labTitle.intrinsicSizeExpansionLength = CGSizeMake(10.0f, 10.0f) ;
        titleCell.titleFont = [UIFont systemFontOfSize:12.0f] ;
        titleCell.titleColor = [UIColor blackColor] ;
    }    
    switch (indexPath.item) {
        case 0: //游戏名称
            titleCell.titleColor = [UIColor blackColor] ;
            titleCell.labTitle.text = self.bettingInfoModel.showName ;
            break;

        case 1: //投注时间
            titleCell.titleColor = [UIColor blackColor] ;
            titleCell.labTitle.text = self.bettingInfoModel.showBettingDate ;
            break;

        case 2: //投注额
            titleCell.titleColor = [UIColor blackColor] ;
            titleCell.labTitle.text = self.bettingInfoModel.showSingleAmount ;
            break;

        case 3: //派彩
            if ([self.bettingInfoModel.mOrderState isEqualToString:@"settle"] && self.bettingInfoModel.mProfitAmount >0) {
                titleCell.labTitle.textColor = colorWithRGB(77, 206, 131) ;
            }else if ([self.bettingInfoModel.mOrderState isEqualToString:@"settle"] && self.bettingInfoModel.mProfitAmount < 0)
            {
                titleCell.labTitle.textColor = colorWithRGB(243, 66, 53) ;
            }else if ([self.bettingInfoModel.mOrderState isEqualToString:@"settle"] &&
                      self.bettingInfoModel.mProfitAmount == 0)
            {
                titleCell.labTitle.textColor = [UIColor blackColor] ;
            }
            titleCell.labTitle.text = self.bettingInfoModel.showProfitAmount ;
            break;

        case 4: //状态
            if ([self.bettingInfoModel.mOrderState isEqualToString:@"settle"]) {
                titleCell.labTitle.textColor = colorWithRGB(77, 206, 131) ;
            }else if ([self.bettingInfoModel.mOrderState isEqualToString:@"pending_settle"])
            {
                titleCell.labTitle.textColor = colorWithRGB(253, 160, 0) ;
            }else
            {
                titleCell.labTitle.textColor = colorWithRGB(234, 94, 94) ;
            }
            titleCell.labTitle.text = self.bettingInfoModel.showStatus ;
            break;

        default:
            break;
    }
    return  titleCell ;
}

- (NSString*)staticCollectionView:(CLStaticCollectionView *)collectionView cellWidthWeightAtIndexPath:(NSUInteger)section
{
    return @"1:1.3:0.8:0.8:0.8" ;
}

@end
