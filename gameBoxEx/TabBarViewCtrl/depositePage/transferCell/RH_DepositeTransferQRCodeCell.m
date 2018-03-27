//
//  RH_DepositeTransferQRCodeCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferQRCodeCell.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_DepositePayAccountModel.h"
#import "UIImageView+WebCache.h"
@interface RH_DepositeTransferQRCodeCell()
@property (weak, nonatomic) IBOutlet UIImageView *qrurlImage;

@end
@implementation RH_DepositeTransferQRCodeCell
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_DepositePayAccountModel *accountModel = ConvertToClassPointer(RH_DepositePayAccountModel, context);
    [self.qrurlImage sd_setImageWithURL:[NSURL URLWithString:accountModel.mQrCodeUrl]];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
