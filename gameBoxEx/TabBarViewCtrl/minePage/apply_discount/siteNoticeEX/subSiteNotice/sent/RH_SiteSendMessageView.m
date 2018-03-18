//
//  RH_SiteSendMessageView.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/12.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_SiteSendMessageView.h"
#import "coreLib.h"
#import "RH_API.h"
#import "MBProgressHUD.h"
#import "RH_ApplyDiscountSiteSendCell.h"
#import "RH_APPDelegate.h"
#define NSNotiCenterSubmitSuccessNT  @"NSNotiCenterSubmitSuccess"


@interface RH_SiteSendMessageView()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backDropView;
@property (weak, nonatomic) IBOutlet UITextField *titelField;
@property (weak, nonatomic) IBOutlet UITextView *contenTextView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *confimBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLba;
@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong, readonly) RH_ApplyDiscountSiteSendCell *applyDiscountSiteSendCell;

@end
@implementation RH_SiteSendMessageView

@synthesize applyDiscountSiteSendCell = _applyDiscountSiteSendCell;
@synthesize placeHolderLabel = _placeHolderLabel;
//-(instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder]) {
//
//    }
//    return self;
//}


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.webView setHidden:YES];
    [self.codeTextField setHidden:YES];
    self.titelField.returnKeyType = UIReturnKeyDone;
    self.titelField.delegate = self;
    self.contenTextView.returnKeyType = UIReturnKeyDone;
    self.contenTextView.delegate = self;
//    self.contenTextView.text = @"请输入内容";
    self.codeTextField.returnKeyType = UIReturnKeyDone;
    self.codeTextField.delegate = self;

    self.backDropView.layer.borderColor = colorWithRGB(226, 226, 226).CGColor;
    self.backDropView.layer.borderWidth = 1.f;
    self.backDropView.layer.masksToBounds = YES;
    self.contenTextView.layer.cornerRadius = 5.f;
    self.contenTextView.layer.borderColor = colorWithRGB(226, 226, 226).CGColor;
    self.contenTextView.layer.borderWidth = 1.f;
    self.contenTextView.clipsToBounds = YES;
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5,300, 20)];
    
    _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    _placeHolderLabel.textColor = [UIColor grayColor];
    _placeHolderLabel.text = @"请输入内容";
    [self.contenTextView addSubview:_placeHolderLabel];
    self.confimBtn.layer.cornerRadius = 3.f;
    if ([THEMEV3 isEqualToString:@"green"]){
        self.confimBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
        self.cancelBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Green;
    }else if ([THEMEV3 isEqualToString:@"red"]){
        self.confimBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
        self.cancelBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Red;
    }else if ([THEMEV3 isEqualToString:@"black"]){
        self.confimBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
        self.cancelBtn.backgroundColor = RH_NavigationBar_BackgroundColor_Black;
    }else{
        self.confimBtn.backgroundColor = RH_NavigationBar_BackgroundColor;
        self.cancelBtn.backgroundColor = RH_NavigationBar_BackgroundColor;
    }
    
    self.confimBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self.confimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confimBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 3.f;
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelBtn.layer.masksToBounds = YES;
    
    self.typeLab.textColor = colorWithRGB(51, 51, 51);
    self.titleLba.textColor = colorWithRGB(51, 51, 51);
}
-(void)setSendModel:(RH_SendMessageVerityModel *)sendModel
{
    _sendModel = sendModel;
    if (sendModel.mIsOpenCaptcha==NO) {
        [self.webView setHidden:YES];
        [self.codeTextField setHidden:YES];
        self.backDropView.frame = CGRectMake(10, 0, screenSize().width-20, 225);
        
        self.confimBtn.whc_CenterX(screenSize().width/4.0).whc_TopSpaceToView(15.0, self.backDropView).whc_Width((screenSize().width-220)/2.0).whc_Height(40) ;
        self.cancelBtn.whc_CenterX(screenSize().width/4.0*3).whc_TopSpaceToView(15.0, self.backDropView).whc_Width((screenSize().width-220)/2.0).whc_Height(40) ;
        
    }
    else if (sendModel.mIsOpenCaptcha==YES){
        [self.codeTextField setHidden:NO];
        [self.webView setHidden:NO];
        self.backDropView.frame = CGRectMake(10, 0, screenSize().width-20, 265);
        self.confimBtn.whc_CenterX(screenSize().width/4.0).whc_TopSpaceToView(15.0, self.backDropView).whc_Width((screenSize().width-220)/2.0).whc_Height(40) ;
        self.cancelBtn.whc_CenterX(screenSize().width/4.0*3).whc_TopSpaceToView(15.0, self.backDropView).whc_Width((screenSize().width-220)/2.0).whc_Height(40) ;
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",appDelegate.domain,sendModel.mCaptcha_value]];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        [self.webView loadRequest:request];//加载
    }
    
}
- (IBAction)favorableSelectedClick:(id)sender {
    UIButton *btn  =sender;
    self.block(btn.frame);
}
- (IBAction)submitClick:(id)sender {
    
    self.submitBlock(self.titelField.text, self.contenTextView.text,self.codeTextField.text);
    [self.titelField resignFirstResponder] ;
    [self.codeTextField resignFirstResponder] ;
    [self.contenTextView resignFirstResponder];
    
    //注册通知
   [[NSNotificationCenter defaultCenter] postNotificationName:@"noti1" object:nil];
    //信息发送成功将文本置为空
    [[NSNotificationCenter defaultCenter] addObserverForName:NSNotiCenterSubmitSuccessNT object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.titelField.text = @"";
        self.contenTextView.text = @"";
        self.codeTextField.text = @"";
       
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSNotiCenterSubmitSuccessNT object:nil];
}
-(RH_ApplyDiscountSiteSendCell *)applyDiscountSiteSendCell
{
    if (!_applyDiscountSiteSendCell) {
        _applyDiscountSiteSendCell = [RH_ApplyDiscountSiteSendCell createInstance];
        _applyDiscountSiteSendCell.frame = CGRectMake(0,0, self.frameWidth, self.frameHeigh);
    }
    return _applyDiscountSiteSendCell;
}

- (IBAction)cancelBtnClick:(id)sender {
    self.titelField.text = @"";
    self.contenTextView.text = @"";
    self.codeTextField.text = @"";
    self.typeLabel.text = @"请选择";
    ifRespondsSelector(self.delegate, @selector(siteSendMessageViewDidTouchCancelBtn:)){
        [self.delegate siteSendMessageViewDidTouchCancelBtn:self];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    ifRespondsSelector(self.delegate, @selector(selectedCodeTextFieldAndChangedKeyboardFrame:)){
        [self.delegate selectedCodeTextFieldAndChangedKeyboardFrame:CGRectMake(0, 0, 0, 0)];
    }
    [self.titelField resignFirstResponder] ;
    [self.codeTextField resignFirstResponder] ;
    return YES;
}
//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    self.contenTextView.text = nil;
//    return YES;
//}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""])
    {
        _placeHolderLabel.text = @"";
    }
    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
    {
        _placeHolderLabel.text = @"请输入内容";
    }
    if ([text isEqualToString:@"\n"]) {
        [self.contenTextView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:))||(action == @selector(cut:));
}

- (void)copy:(UIMenuController *)menu
{
    if ([self.contenTextView.text isEqualToString:@""]) {
        return;
    }
}
- (void)cut:(UIMenuController *)menu
{
    if ([self.contenTextView.text isEqualToString:@""]) {
        return;
    }
}
- (IBAction)selectedCodeTextField:(id)sender {
    ifRespondsSelector(self.delegate, @selector(selectedCodeTextFieldAndChangedKeyboardFrame:)){
        [self.delegate selectedCodeTextFieldAndChangedKeyboardFrame:self.codeTextField.frame];
    }
}


@end
