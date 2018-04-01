//
//  RH_DepositeTransferWXinInfoCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferWXinInfoCell.h"
#import "coreLib.h"
#import "RH_API.h"
#import "RH_DepositeTransferChannelModel.h"
@interface RH_DepositeTransferWXinInfoCell ()
@property (weak, nonatomic) IBOutlet UIButton *accountInfo;
@property (weak, nonatomic) IBOutlet UIView *accountInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *bankIconImage;
@property (weak, nonatomic) IBOutlet UILabel *personIdNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;

@end
@implementation RH_DepositeTransferWXinInfoCell
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_DepositeTransferListModel *listModel = ConvertToClassPointer(RH_DepositeTransferListModel, context);
    self.personIdNumLabel.text = [NSString stringWithFormat:@"%@",listModel.mAccount] ;
    self.personNameLabel.text = listModel.mFullName;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.accountInfo.layer.cornerRadius = 5.f;
    self.accountInfo.layer.masksToBounds = YES;
    self.accountInfoView.layer.cornerRadius = 10.f;
    self.accountInfoView.layer.masksToBounds = YES;
    self.accountInfoView.layer.borderWidth = 1.f;
    self.accountInfoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
