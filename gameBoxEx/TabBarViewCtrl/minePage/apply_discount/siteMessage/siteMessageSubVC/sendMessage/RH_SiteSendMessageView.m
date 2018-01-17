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
@interface RH_SiteSendMessageView()
@property (weak, nonatomic) IBOutlet UIView *backDropView;
@property (weak, nonatomic) IBOutlet UITextField *titelField;
@property (weak, nonatomic) IBOutlet UITextView *contenTextView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end
@implementation RH_SiteSendMessageView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self.webView setHidden:YES];
        [self.codeTextField setHidden:YES];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backDropView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backDropView.layer.borderWidth = 1.f;
    self.backDropView.layer.masksToBounds = YES;
}
-(void)setSendModel:(RH_SendMessageVerityModel *)sendModel
{
    _sendModel = sendModel;
    if (sendModel.mIsOpenCaptcha==NO) {
        [self.webView setHidden:YES];
        [self.codeTextField setHidden:YES];
    }
    else if (sendModel.mIsOpenCaptcha==YES){
        [self.codeTextField setHidden:NO];
        [self.webView setHidden:NO];
//        [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://test01.ampinplayopt0matrix.com",sendModel.mCaptcha_value]]];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://test01.ampinplayopt0matrix.com",sendModel.mCaptcha_value]];//创建URL
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
}
@end
