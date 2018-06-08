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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveToPhoneCenterX;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
//第三方平台的地址
@property (nonatomic,strong)NSString *mobileStr;
@end
@implementation RH_DepositeTransferQRCodeCell
+(CGFloat)heightForCellWithInfo:(NSDictionary *)info tableView:(UITableView *)tableView context:(id)context
{
    RH_DepositeTransferListModel *listmodel = ConvertToClassPointer(RH_DepositeTransferListModel, context);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0]};//指定字号
    CGRect rect = [listmodel.mRemark boundingRectWithSize:CGSizeMake(MainScreenW - 30, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return 140+rect.size.height;
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_DepositeTransferListModel *listmodel = ConvertToClassPointer(RH_DepositeTransferListModel, context);
    self.transferModel = listmodel ;
//    [self.qrurlImage sd_setImageWithURL:[NSURL URLWithString:listmodel.qrShowCover]];
    [self.qrurlImage sd_setImageWithURL:[NSURL URLWithString:listmodel.qrShowCover] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    
    if ([listmodel.mBankCode isEqualToString:@"qqwallet"]) {
        [self.openAppBtn setTitle:@"启动QQ支付" forState:UIControlStateNormal];
        self.mobileStr = @"mqq://";
    }
    else if ([listmodel.mBankCode isEqualToString:@"bdwallet"]) {
        [self.openAppBtn setTitle:@"启动百度支付" forState:UIControlStateNormal];
        self.mobileStr = @"baidu://";
    }
    else if ([listmodel.mBankCode isEqualToString:@"other"]) {
        [self.openAppBtn setTitle:@"启动其他方式支付" forState:UIControlStateNormal];
        self.openAppBtn.hidden = YES;
        self.saveToPhoneCenterX.constant = 0;
    }
    else if ([listmodel.mBankCode isEqualToString:@"alipay"]) {
        [self.openAppBtn setTitle:@"启动支付宝支付" forState:UIControlStateNormal];
        self.mobileStr = @"alipay://";
    }
    else if ([listmodel.mBankCode isEqualToString:@"wechatpay"]) {
        [self.openAppBtn setTitle:@"启动微信支付" forState:UIControlStateNormal];
        self.mobileStr = @"weixin://";
    }
    else if ([listmodel.mBankCode isEqualToString:@"onecodepay"]) {
        [self.openAppBtn setTitle:@"启动一码付支付" forState:UIControlStateNormal];
        self.openAppBtn.hidden = YES;
        self.saveToPhoneCenterX.constant = 0;
    }
    else if ([listmodel.mBankCode isEqualToString:@"jdwallet"]) {
        [self.openAppBtn setTitle:@"启动京东支付" forState:UIControlStateNormal];
        self.mobileStr = @"openapp.jdmoble://";
    }
    self.remarkLabel.text = listmodel.mRemark;

}
- (IBAction)saveToPhone:(id)sender {
    ifRespondsSelector(self.delegate, @selector(depositeTransferQRCodeCellDidTouchSaveToPhoneWithImageUrl:)){
        [self.delegate depositeTransferQRCodeCellDidTouchSaveToPhoneWithImageUrl:self.transferModel.qrShowCover] ;
    }
}
- (IBAction)openOtherAppClick:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.mobileStr]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.mobileStr]];
    }
    else
    {
        showMessage(self, @"提示", @"未安装相关软件");
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
    if ([THEMEV3 isEqualToString:@"green"]) {
        [self.saveTophoneBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Green];
        [self.openAppBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Green];
    }else if ([THEMEV3 isEqualToString:@"red"]){
        [self.saveTophoneBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Red];
        [self.openAppBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Red];
    }else if ([THEMEV3 isEqualToString:@"black"]){
        [self.saveTophoneBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Black];
        [self.openAppBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Black];
    }else if ([THEMEV3 isEqualToString:@"blue"]){
        [self.saveTophoneBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Blue];
        [self.openAppBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Blue];
    }else if ([THEMEV3 isEqualToString:@"orange"]){
        [self.saveTophoneBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Orange];
        [self.openAppBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Orange];
    }else if ([THEMEV3 isEqualToString:@"red_white"]){
        [self.saveTophoneBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Red_White];
        [self.openAppBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Red_White];
    }else if ([THEMEV3 isEqualToString:@"green_white"]){
        [self.saveTophoneBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Green_White];
        [self.openAppBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Green_White];
    }else if ([THEMEV3 isEqualToString:@"orange_white"]){
        [self.saveTophoneBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Orange_White];
        [self.openAppBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Orange_White];
    }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
        [self.saveTophoneBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Coffee_White];
        [self.openAppBtn setBackgroundColor:RH_NavigationBar_BackgroundColor_Coffee_White];
    }else{
        [self.saveTophoneBtn setBackgroundColor:colorWithRGB(23, 102, 203)];
        [self.openAppBtn setBackgroundColor:colorWithRGB(23, 102, 203)];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
