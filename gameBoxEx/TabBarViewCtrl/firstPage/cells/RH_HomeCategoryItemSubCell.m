//
//  RH_HomeCategoryItemSubCell.m
//  gameBoxEx
//
//  Created by luis on 2017/12/21.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_HomeCategoryItemSubCell.h"
#import "coreLib.h"
#import "RH_LotteryAPIInfoModel.h"
#import "RH_LotteryInfoModel.h"

@interface RH_HomeCategoryItemSubCell()<CLMaskViewDataSource>
@property (nonatomic,strong) IBOutlet UIImageView *imgIcon ;
@property (nonatomic,strong) IBOutlet UILabel *labTitle ;
@property (nonatomic,strong) id categoryItem  ;
@end

@implementation RH_HomeCategoryItemSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = colorWithRGB(242, 242, 242) ;
    self.contentView.layer.cornerRadius = 6.0f ;
    self.contentView.layer.masksToBounds = YES ;
    
    self.labTitle.font = [UIFont systemFontOfSize:12.0f]    ;
    self.labTitle.textColor =  RH_Label_DefaultTextColor ;
    
    self.selectionOption = CLSelectionOptionHighlighted ;
    self.selectionColor =  [UIColor blueColor] ;
    self.selectionColorAlpha = 0.3f ;
    self.labTitle.whc_CenterY(38);
    self.imgIcon.whc_Center(0, -15).whc_Width(58).whc_Height(58);
}

-(UIView *)showSelectionView
{
    return self.contentView ;
}

-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    self.categoryItem = context ;
    if ([self.categoryItem isKindOfClass:[RH_LotteryAPIInfoModel class]]){
        RH_LotteryAPIInfoModel *lotteryAPIInfoModel = ConvertToClassPointer(RH_LotteryAPIInfoModel, self.categoryItem) ;
        self.labTitle.text =  lotteryAPIInfoModel.mName ;
        [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:lotteryAPIInfoModel.showCover]] ;
    }else if ([self.categoryItem isKindOfClass:[RH_LotteryInfoModel class]]){
        RH_LotteryInfoModel *lotteryInfoModel = ConvertToClassPointer(RH_LotteryInfoModel, self.categoryItem) ;
        self.labTitle.text =  lotteryInfoModel.mName ;
        [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:lotteryInfoModel.showCover]] ;
    }
}

@end
