//
//  RH_PromoTableCell.m
//  gameBoxEx
//
//  Created by luis on 2018/1/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_PromoTableCell.h"
#import "RH_DiscountActivityModel.h"

@interface RH_PromoTableCell()
@property (nonatomic,weak) IBOutlet UIImageView *activeImageView ;
@property (nonatomic,strong) RH_DiscountActivityModel *discountActivityModel ;
@end


@implementation RH_PromoTableCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    return floor((282.0/426.0)*tableView.frameWidth)  ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionOption = CLSelectionOptionHighlighted ;
    self.selectionColor = RH_Cell_DefaultHolderColor ;
    self.selectionColorAlpha = 0.5f ;
}

-(UIView *)showSelectionView
{
    return self.activeImageView ;
}

-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.discountActivityModel = ConvertToClassPointer(RH_DiscountActivityModel, context) ;
    [self.activeImageView sd_setImageWithURL:[NSURL URLWithString:self.discountActivityModel.showPhoto]] ;
}

@end
