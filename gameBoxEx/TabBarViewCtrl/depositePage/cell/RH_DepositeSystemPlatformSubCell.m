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
#import "RH_DepositePayAccountModel.h"
@interface RH_DepositeSystemPlatformSubCell()
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payWayImage;

@end
@implementation RH_DepositeSystemPlatformSubCell
-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    RH_DepositePayAccountModel *accountModel = ConvertToClassPointer(RH_DepositePayAccountModel, context);
    self.payWayLabel.text = accountModel.mBankName;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = colorWithRGB(242, 242, 242);
    self.layer.cornerRadius = 2.f;
    self.layer.masksToBounds = YES;
}

@end
