//
//  RH_DepositeSystemPlatformSubCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeSystemPlatformSubCell.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_DepositeTransferChannelModel.h"

@interface RH_DepositeSystemPlatformSubCell()
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payWayImage;

@end
@implementation RH_DepositeSystemPlatformSubCell
-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    RH_DepositeTransferListModel *listModel = ConvertToClassPointer(RH_DepositeTransferListModel, context);
    self.payWayLabel.text = listModel.mPayName;
    [self.payWayImage sd_setImageWithURL:[NSURL URLWithString:listModel.showCover]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = colorWithRGB(242, 242, 242);
    self.layer.cornerRadius = 2.f;
    self.layer.masksToBounds = YES;
}

@end
