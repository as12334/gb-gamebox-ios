//
//  RH_DepositeBitcionCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/31.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeBitcionCell.h"
#import "coreLib.h"

#import "RH_DepositeTransferChannelModel.h"

#import "RH_DespositeBitCoinStaticDataCell.h"

@interface RH_DepositeBitcionCell()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bitcoinAdressTextfield;

@property (weak, nonatomic) IBOutlet UITextField *txidTextfield;
@property (weak, nonatomic) IBOutlet UITextField *bitcoinNumTextfield;
@property (weak, nonatomic) IBOutlet UITextField *bitcoinChangeTimeTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *bitcoinIcon;
@property (weak, nonatomic) IBOutlet UITextView *bitcoinNoteTextview;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *submitBtnBackView;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (nonatomic,strong)RH_DepositeTransferListModel *listModel;
@property (nonatomic,strong,readonly) RH_DespositeBitCoinStaticDataCell *bitcoinStaticDateCell ;
@property (weak, nonatomic) IBOutlet UIView *accountInfoBakcView;
@property (weak, nonatomic) IBOutlet UIView *accountInfoView;
@property (weak, nonatomic) IBOutlet UIButton *savePhoneBtn;

@end
@implementation RH_DepositeBitcionCell
static NSString *content =  @"温馨提示：\n* 为了方便系统快速完成转账，请输入正确的txId、交易时间，以加快系统入款速度。\n* 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服";
@synthesize bitcoinStaticDateCell = _bitcoinStaticDateCell ;
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_DepositeTransferListModel *listeModel = ConvertToClassPointer(RH_DepositeTransferListModel, context);
    self.listModel = listeModel;
//    [self.bitcoinIcon sd_setImageWithURL:[NSURL URLWithString:self.listModel.accountImgCover]];
    [self.bitcoinIcon sd_setImageWithURL:[NSURL URLWithString:self.listModel.showCover] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    
    self.personNameLabel.text = self.listModel.mFullName;
//    [self.qrImageView sd_setImageWithURL:[NSURL URLWithString:self.listModel.qrShowCover]];
    [self.qrImageView sd_setImageWithURL:[NSURL URLWithString:self.listModel.qrShowCover] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self =[super initWithCoder:aDecoder]) {
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    WHC_StackView *stackView = [[WHC_StackView alloc] init];
    stackView.userInteractionEnabled = YES ;
    [self addSubview:stackView];
    stackView.whc_RightSpace(0).whc_TopSpaceToView(15, _bitcoinNumTextfield).whc_Width(200).whc_Height(38) ;
    stackView.whc_Column = 1;
    stackView.whc_HSpace = 10;
    stackView.whc_VSpace = 10;
    stackView.whc_Orientation = Horizontal;
    [stackView addSubview:self.bitcoinStaticDateCell];
    stackView.whc_Edge = UIEdgeInsetsMake(0, 0, 0, 0);
    [stackView whc_StartLayout];
    _bitConDate = [NSDate date] ;
    // Initialization code
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.layer.masksToBounds = YES;
    self.bitcoinAdressTextfield.delegate = self;
    self.txidTextfield.delegate = self;
    self.bitcoinNumTextfield.delegate = self;
    self.bitcoinChangeTimeTextfield.delegate = self;
    if ([THEMEV3 isEqualToString:@"green"]) {
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
        self.savePhoneBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
    }else if ([THEMEV3 isEqualToString:@"black"]){
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
        self.savePhoneBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
    }else if ([THEMEV3 isEqualToString:@"blue"]){
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
        self.savePhoneBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
    }else if ([THEMEV3 isEqualToString:@"red"]){
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
        self.savePhoneBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
    }else if ([THEMEV3 isEqualToString:@"orange"]){
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
        self.savePhoneBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Orange;
    }else if ([THEMEV3 isEqualToString:@"red_white"]){
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Red_White;
        self.savePhoneBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Red_White;
    }else if ([THEMEV3 isEqualToString:@"green_white"]){
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green_White;
        self.savePhoneBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green_White;
    }else if ([THEMEV3 isEqualToString:@"orange_white"]){
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Orange_White;
        self.savePhoneBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Orange_White;
    }else if ([THEMEV3 isEqualToString:@"coffee_white"]){
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_White;
        self.savePhoneBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Coffee_White;
    }else{
        self.submitBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
        self.savePhoneBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Blue;
    }
    self.submitBtnBackView.backgroundColor = colorWithRGB(242, 242, 242);
    self.noteTextView.backgroundColor = colorWithRGB(242, 242, 242);
    self.accountInfoBakcView.layer.cornerRadius = 5.f;
    self.accountInfoBakcView.layer.masksToBounds = YES;
    self.accountInfoView.layer.cornerRadius = 3.f;
    self.accountInfoView.layer.masksToBounds = YES;
    self.savePhoneBtn.layer.cornerRadius = 5.f;
    self.savePhoneBtn.layer.masksToBounds = YES;
    self.bitcoinNoteTextview.text = @"扫码支付存款到比特币账户，\n自动到账。";
    [self setupUI];
}
-(void)setupUI{
    // 设置属性
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 设置行间距
    paragraphStyle.paragraphSpacing = 2; // 段落间距
    paragraphStyle.lineSpacing = 10;      // 行间距
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:colorWithRGB(102,102, 102),
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    [attrStr addAttributes:@{
                             NSLinkAttributeName:@"点击联系在线客服"
                             }
                     range:[content rangeOfString:@"点击联系在线客服"]];
    self.noteTextView.linkTextAttributes = @{NSForegroundColorAttributeName:colorWithRGB(23, 102, 187)}; // 修改可点击文字的颜色
    self.noteTextView.attributedText = attrStr;
    self.noteTextView.editable = NO;
    self.noteTextView.scrollEnabled = NO;
    self.noteTextView.delegate = self;
}
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSRange range = [content rangeOfString:@"点击联系在线客服"];
    if (characterRange.location == range.location) {
        // 做你想做的事
        ifRespondsSelector(self.delegate, @selector(touchTextViewCustomPushCustomViewController:)){
            [self.delegate touchTextViewCustomPushCustomViewController:self];
        }
        
    }
    return YES;
}
- (IBAction)submitClick:(id)sender {
 
    [self.bitcoinAdressTextfield resignFirstResponder];
    [self.txidTextfield resignFirstResponder];
    [self.bitcoinNumTextfield resignFirstResponder];
    [self.bitcoinChangeTimeTextfield resignFirstResponder];
    ifRespondsSelector(self.delegate, @selector(depositeBitcionCellSubmit:)){
        [self.delegate depositeBitcionCellSubmit:self] ;
    }
    
}
- (IBAction)saveToPhone:(id)sender {
    ifRespondsSelector(self.delegate, @selector(depositeBitcionCellDidTouchSaveToPhoneWithUrl:)){
        [self.delegate depositeBitcionCellDidTouchSaveToPhoneWithUrl:self.listModel.qrShowCover] ;
    }
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.bitcoinAdressStr = self.bitcoinAdressTextfield.text;
    self.txidStr = self.txidTextfield.text;
    self.bitcoinNumStr = self.bitcoinNumTextfield.text;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    ifRespondsSelector(self.delegate, @selector(depositeBitcionCellUpframe:)){
        [self.delegate depositeBitcionCellUpframe:self];
    }
    return YES;
}

-(RH_DespositeBitCoinStaticDataCell *)bitcoinStaticDateCell
{
    if (!_bitcoinStaticDateCell) {
        _bitcoinStaticDateCell = [RH_DespositeBitCoinStaticDataCell createInstance] ;
        [_bitcoinStaticDateCell updateUIWithDate:_bitConDate] ;
        [_bitcoinStaticDateCell addTarget:self Selector:@selector(bitcoinStaticDateCellHandle)];
    }
    return _bitcoinStaticDateCell ;
}

-(void)bitcoinStaticDateCellHandle
{
    ifRespondsSelector(self.delegate, @selector(depositeBitcionCellDidTouchTimeSelectView:DefaultDate:)){
        [self.delegate depositeBitcionCellDidTouchTimeSelectView:self DefaultDate:_bitConDate] ;
    }

}

-(void)setBitConDate:(NSDate *)bitConDate
{
    if (![_bitConDate isEqualToDate:bitConDate]){
        _bitConDate = bitConDate;
        [self.bitcoinStaticDateCell updateUIWithDate:_bitConDate];
    }
}

@end
