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
    NSString *imageStr = [NSString stringWithFormat:@"%@",self.transferModel.mIconUrl];
    [self.payforIcon sd_setImageWithURL:[NSURL URLWithString:imageStr]];
}
@end
