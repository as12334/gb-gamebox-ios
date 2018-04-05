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
@property (nonatomic,strong)NSString *content;
@end
@implementation RH_DepositeTransferReminderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.reminderTextView.backgroundColor = colorWithRGB(242, 242, 242);
    self.backgroundColor = colorWithRGB(242, 242, 242);
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.content = @"";
     NSString *nameStr = ConvertToClassPointer(NSString, context);
    if ([nameStr isEqualToString:@"company"]) {
        self.content = @"温馨提示\n* 先查看要入款的银行账号信息，然后通过网上银行或手机银行进行转账，转账成功后再如实提交转账信息，财务专员查收到信息后会及时添加您的款项。\n* 请尽可能选择同行办理转账，可快速到账。\n* 存款完成后，保留单据以利核对并确保您的权益。\n* 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服";
    }
    else if ([nameStr isEqualToString:@"wechat"]||[nameStr isEqualToString:@"alipay"]||[nameStr isEqualToString:@"qq"]||[nameStr isEqualToString:@"jd"]||[nameStr isEqualToString:@"bd"]) {
        self.content =@"温馨提示：\n* 请先搜索账号或扫描二维码添加好友。\n* 支付成功后，请等待几秒钟，提示「支付成功」按确认键后再关闭支付窗口。\n* 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服";
    }
    else if ([nameStr isEqualToString:@"onecodepay"]) {
        self.content = @"温馨提示：\n* 五码合一，使用网银，支付宝，微信，QQ钱包，京东钱包均可扫描二维码进行转账存款。\n* 支付成功后，请等待几秒钟，提示「支付成功」按确认键后再关闭支付窗口。\n* 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服";
    }
    else if ([nameStr isEqualToString:@"counter"]) {
        self.content = @"温馨提示\n* 先查看要入款的银行账号信息，然后通过网上银行或手机银行进行转账，转账成功后再如实提交转账信息，财务专员查收到信息后会及时添加您的款项。\n* 请尽可能选择同行办理转账，可快速到账。\n* 存款完成后，保留单据以利核对并确保您的权益。\n* 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服";
    }
    else if ([nameStr isEqualToString:@"other"]) {
        self.content = @"温馨提示：\n* 请先搜索其他方式账号或扫描二维码添加好友。\n* 支付成功后，请等待几秒钟，提示「支付成功」按确认键后再关闭支付窗口。\n* 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服";
    }
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
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:self.content attributes:attributes];
    [attrStr addAttributes:@{
                             NSLinkAttributeName:@"点击联系在线客服"
                             }
                     range:[self.content rangeOfString:@"点击联系在线客服"]];
    _reminderTextView.linkTextAttributes = @{NSForegroundColorAttributeName:colorWithRGB(23, 102, 187)}; // 修改可点击文字的颜色
    _reminderTextView.attributedText = attrStr;
    _reminderTextView.editable = NO;
    _reminderTextView.scrollEnabled = NO;
    _reminderTextView.delegate = self;
}
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSRange range = [self.content rangeOfString:@"点击联系在线客服"];
    if (characterRange.location == range.location) {
        // 做你想做的事
        ifRespondsSelector(self.delegate, @selector(touchTransferReminderTextViewPushCustomViewController:)){
            [self.delegate touchTransferReminderTextViewPushCustomViewController:self];
        }
        
    }
    return YES;
}
@end
