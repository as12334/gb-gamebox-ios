//
//  RH_DepositeReminderCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/3/22.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_DepositeReminderCell.h"
#import "coreLib.h"
@interface RH_DepositeReminderCell()
@property (weak, nonatomic) IBOutlet UITextView *reminderTextView;
@property (nonatomic,strong)NSString *content;
@end
@implementation RH_DepositeReminderCell
- (void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    self.content = @"";
    NSMutableArray *reminderArray = ConvertToClassPointer(NSMutableArray, context);
    NSString *nameStr = reminderArray[0];
    NSString *typeCode;
    if (reminderArray.count==2) {
         typeCode = reminderArray[1];
    }
    if ([nameStr isEqualToString:@"online"]) {
        self.content = @"温馨提示：\n• 为了提高对账速度及成功率，当前支付方式已开随机额度，请输入整数存款金额，将随机增加0.01~0.99元！\n• 请保留好转账单据作为核对证明。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。 ";
    }
    else if ([nameStr isEqualToString:@"wechat"]||[nameStr isEqualToString:@"alipay"]||[nameStr isEqualToString:@"qq"]||[nameStr isEqualToString:@"jd"]||[nameStr isEqualToString:@"bd"]||[nameStr isEqualToString:@"unionpay"]) {
            if ([typeCode isEqualToString:@"1"]) {
                self.content =@"温馨提示：\n• 存款金额请加以小数点或尾数，以便区别。如充值200元，请输入201元或200.1之类小数。\n• 如有任何疑问，请联系在线客服获取帮助。";
            }
            else if ([typeCode isEqualToString:@"2"]){
                self.content = @"温馨提示：\n• 为了提高对账速度及成功率，当前支付方式已开随机额度，请输入整数存款金额，将随机增加0.01~0.99元！\n• 支付成功后，请等待几秒钟，提示「支付成功」按确认键后再关闭支付窗口。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。 ";
            }
        
    }
    else if ([nameStr isEqualToString:@"onecodepay"]) {
        self.content = @"温馨提示：\n• 存款金额请加以小数点或尾数，以便区别。如充值200元，请输入201元或200.1之类小数。\n• 如有任何疑问，请联系在线客服获取帮助。";
    }
    else if ([nameStr isEqualToString:@"company"]) {
        self.content = @"温馨提示：\n• 存款金额请加以小数点或尾数，以便区别。如充值200元，请输入201元或200.1之类小数。\n• 如有任何疑问，请联系在线客服获取帮助。";
    }
    else if ([nameStr isEqualToString:@"counter"]) {
        self.content = @"温馨提示：\n• 存款金额请加以小数点或尾数，以便区别。如充值200元，请输入201元或200.1之类小数。\n• 如有任何疑问，请联系在线客服获取帮助。";
    }
    else if ([nameStr isEqualToString:@"other"]) {
        self.content = @"温馨提示：\n• 存款金额请加以小数点或尾数，以便区别。如充值200元，请输入201元或200.1之类小数。\n• 如有任何疑问，请联系在线客服获取帮助。";
    }
    else if ([nameStr isEqualToString:@"easy"]) {
        self.content = @"温馨提示：\n• 当前支付额度必须精确到小数点，请严格核对您的转账金额精确到分，如：100.51，否则无法提高对账速度及成功率，谢谢您的配合。\n• 如有任何疑问，请联系在线客服获取帮助。";
    }

    [self setupUI];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = colorWithRGB(242, 242, 242);
    self.reminderTextView.backgroundColor = colorWithRGB(242, 242, 242);
}
-(void)setupUI{
    if (self.content.length!=0) {
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
        _reminderTextView.attributedText = attrStr;
        _reminderTextView.editable = NO;
        _reminderTextView.scrollEnabled = NO;
         }
}

@end
