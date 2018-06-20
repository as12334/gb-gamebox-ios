//
//  RH_DepositeSubmitCircleCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeSubmitCircleCell.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_DepositOriginseachSaleModel.h"
@interface RH_DepositeSubmitCircleCell()
@property (weak, nonatomic) IBOutlet UILabel *chargNameLabel;


@end
@implementation RH_DepositeSubmitCircleCell
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_DepositOriginseachSaleDetailsModel *detailsModel = ConvertToClassPointer(RH_DepositOriginseachSaleDetailsModel, context);
    self.chargNameLabel.text = detailsModel.mActivityName;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
