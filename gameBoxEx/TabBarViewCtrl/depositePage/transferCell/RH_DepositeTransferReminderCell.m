//
//  RH_DepositeTransferReminderCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeTransferReminderCell.h"
#import "coreLib.h"
@interface RH_DepositeTransferReminderCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *reminderTextView;

@end
@implementation RH_DepositeTransferReminderCell
static NSString *content = @"温馨提示\n*为了提高对账速度及成功率，当前支付方式已开通随机额度，请输入整数存款金额，将随机增加0.11~0.99元。\n*请保留好转账单据以便核对证明。\n*如果出现充值失败或充值未到账的情况，请联系在线客服寻求帮助。点击联系在线客服";
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupUI];
}
-(void)setupUI{
    // 设置属性
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 设置行间距
    paragraphStyle.paragraphSpacing = 2; // 段落间距
    paragraphStyle.lineSpacing = 10;      // 行间距
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:[UIColor blackColor],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    [attrStr addAttributes:@{
                             NSLinkAttributeName:@"点击联系在线客服"
                             }
                     range:[content rangeOfString:@"点击联系在线客服"]];
    _reminderTextView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]}; // 修改可点击文字的颜色
    _reminderTextView.attributedText = attrStr;
    _reminderTextView.editable = NO;
    _reminderTextView.scrollEnabled = NO;
    _reminderTextView.delegate = self;
}
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSRange range = [content rangeOfString:@"点击联系在线客服"];
    if (characterRange.location == range.location) {
        // 做你想做的事
        ifRespondsSelector(self.delegate, @selector(touchTransferReminderTextViewPushCustomViewController:)){
            [self.delegate touchTransferReminderTextViewPushCustomViewController:self];
        }
        
    }
    return YES;
}
@end
