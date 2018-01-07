//
//  RH_GameListCollectionViewCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/5.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_GameListCollectionViewCell.h"
#import "coreLib.h"
#import "RH_LotteryInfoModel.h"

@interface  RH_GameListCollectionViewCell()
@property(nonatomic,strong) IBOutlet UILabel *labName;
@property(nonatomic,strong) IBOutlet UIImageView *imageView;

@end

@implementation RH_GameListCollectionViewCell

+(CGSize)sizeForViewWithInfo:(NSDictionary *)info containerViewSize:(CGSize)containerViewSize context:(id)context
{
    return CGSizeMake((containerViewSize.width-50)/4, (containerViewSize.width-50)/4*7/5);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionOption = CLSelectionOptionHighlighted ;
    self.selectionColor = RH_Cell_DefaultHolderColor ;
    self.selectionColorAlpha = 0.3f ;
}

-(UIView *)showSelectionView
{
    return self.imageView ;
}

-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    RH_LotteryInfoModel *lotteryInfoModel = ConvertToClassPointer(RH_LotteryInfoModel, context) ;
    self.labName.text = lotteryInfoModel.mName ;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:lotteryInfoModel.showCover]] ;
}

@end
