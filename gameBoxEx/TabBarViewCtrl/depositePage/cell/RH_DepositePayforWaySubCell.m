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

@property (nonatomic,strong)RH_DepositeTransferModel *transferModel;
@end
@implementation RH_DepositePayforWaySubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
-(void)updateViewWithInfo:(NSDictionary *)info context:(id)context
{
    self.transferModel = ConvertToClassPointer(RH_DepositeTransferModel, context);
    self.payforTitle.text = self.transferModel.mName;
    NSLog(@"transferModel===%@",self.transferModel.mName);
//    [self.payforIcon sd_setImageWithURL:[NSURL URLWithString:self.transferModel.showCover]];
    [self.payforIcon sd_setImageWithURL:[NSURL URLWithString:self.transferModel.showCover] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
}
@end
