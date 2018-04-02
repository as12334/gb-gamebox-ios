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
#import "RH_DepositeTransferChannelModel.h"
#import "UIImageView+WebCache.h"
@interface RH_DepositeTransferQRCodeCell()
@property (weak, nonatomic) IBOutlet UIImageView *qrurlImage;
@property(nonatomic,strong)RH_DepositeTransferListModel *transferModel ;
@property (weak, nonatomic) IBOutlet UIView *qrbackView;

@property (weak, nonatomic) IBOutlet UIButton *saveTophoneBtn;

@property (weak, nonatomic) IBOutlet UIButton *openAppBtn;
@end
@implementation RH_DepositeTransferQRCodeCell
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_DepositeTransferListModel *listmodel = ConvertToClassPointer(RH_DepositeTransferListModel, context);
    self.transferModel = listmodel ;
    [self.qrurlImage sd_setImageWithURL:[NSURL URLWithString:listmodel.qrShowCover]];
    
}
- (IBAction)saveToPhone:(id)sender {
    ifRespondsSelector(self.delegate, @selector(depositeTransferQRCodeCellDidTouchSaveToPhoneWithImageUrl:)){
        [self.delegate depositeTransferQRCodeCellDidTouchSaveToPhoneWithImageUrl:self.transferModel.qrShowCover] ;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.qrbackView.layer.cornerRadius = 3.f;
    self.qrbackView.layer.masksToBounds = YES;
    self.qrbackView.layer.borderColor = colorWithRGB(242, 242, 242).CGColor;
    self.qrbackView.layer.borderWidth = 1.f;
    self.saveTophoneBtn.layer.cornerRadius = 3.f;
    self.saveTophoneBtn.layer.masksToBounds = YES;
    self.openAppBtn.layer.cornerRadius = 3.f;
    self.openAppBtn.layer.masksToBounds = YES;
    [self.saveTophoneBtn setBackgroundColor:colorWithRGB(23, 102, 203)];
    [self.openAppBtn setBackgroundColor:colorWithRGB(23, 102, 203)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
