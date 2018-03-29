//
//  RH_DepositePayforWaySubCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositePayforWaySubCell.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_DepositeTransferModel.h"
@interface RH_DepositePayforWaySubCell()
@property (weak, nonatomic) IBOutlet UIImageView *payforIcon;
@property (weak, nonatomic) IBOutlet UILabel *payforTitle;
@property (nonatomic,strong)RH_DepositePayModel *payModel;
@end
@implementation RH_DepositePayforWaySubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.layer.cornerRadius = 2;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = colorWithRGB(23, 102, 187).CGColor;
//    self.layer.masksToBounds = YES;
}
-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    self.payModel = ConvertToClassPointer(RH_DepositePayModel, context);
    self.payforTitle.text = self.payModel.mName;
    NSString *imageStr = [NSString stringWithFormat:@"test01.ampinplayopt0matrix.com%@",self.payModel.mUrl
                          ];
    [self.payforIcon sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    if ([self.payModel.mName isEqualToString:@"在线支付"]) {
        self.payforIcon.image = [UIImage imageNamed:@"1"];
    }
    else if ([self.payModel.mName isEqualToString:@"网银存款"]){
        self.payforIcon.image = [UIImage imageNamed:@"2"];
    }
    else if ([self.payModel.mName isEqualToString:@"微信支付"]){
        self.payforIcon.image = [UIImage imageNamed:@"3"];
    }
    else if ([self.payModel.mName isEqualToString:@"支付宝支付"]){
        self.payforIcon.image = [UIImage imageNamed:@"4"];
    }
    else if ([self.payModel.mName isEqualToString:@"QQ钱包"]){
        self.payforIcon.image = [UIImage imageNamed:@"5"];
    }
    else if ([self.payModel.mName isEqualToString:@"京东钱包"]){
        self.payforIcon.image = [UIImage imageNamed:@"6"];
    }
    else if ([self.payModel.mName isEqualToString:@"百度钱包"]){
        self.payforIcon.image = [UIImage imageNamed:@"7"];
    }
    else if ([self.payModel.mName isEqualToString:@"比特币"]){
        self.payforIcon.image = [UIImage imageNamed:@"8"];
    }
    else if ([self.payModel.mName isEqualToString:@"一码付"]){
        self.payforIcon.image = [UIImage imageNamed:@"9"];
    }
    else if ([self.payModel.mName isEqualToString:@"银联扫码"]){
        self.payforIcon.image = [UIImage imageNamed:@"10"];
    }
    else if ([self.payModel.mName isEqualToString:@"快充中心"]){
        self.payforIcon.image = [UIImage imageNamed:@"11"];
    }
    else if ([self.payModel.mName isEqualToString:@"柜员机"]){
        self.payforIcon.image = [UIImage imageNamed:@"12"];
    }
    else if ([self.payModel.mName isEqualToString:@"易收付"]){
        self.payforIcon.image = [UIImage imageNamed:@"13"];
    }
    else if ([self.payModel.mName isEqualToString:@"其他"]){
        self.payforIcon.image = [UIImage imageNamed:@"14"];
    }
}
@end
